<#
.SYNOPSIS
Deploys (creates or updates) a Microsoft Entra Conditional Access policy from JSON.

.DESCRIPTION
- Reads a policy JSON file
- Resolves named locations referenced as NAME:<displayName>
- Converts JSON into a hashtable suitable for Microsoft Graph
- Creates the policy if it does not exist
- Updates the policy if it already exists
- Stops if duplicate policies with the same display name already exist

.PARAMETER JsonPath
Path to the policy JSON file.

.EXAMPLE
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$JsonPath
)

$ErrorActionPreference = "Stop"

function Ensure-GraphReady {
    try {
        Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop
    }
    catch {
        throw "Microsoft.Graph.Identity.SignIns module is not available. Run .\scripts\deployment\install-prereqs.ps1 first."
    }

    $requiredScopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Policy.Read.All",
        "Directory.Read.All",
        "Application.Read.All"
    )

    $ctx = Get-MgContext -ErrorAction SilentlyContinue

    if (-not $ctx) {
        Write-Host "Not connected to Microsoft Graph. Connecting now..."
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null
        return
    }

    $missingScopes = @()
    foreach ($scope in $requiredScopes) {
        if ($ctx.Scopes -notcontains $scope) {
            $missingScopes += $scope
        }
    }

    if ($missingScopes.Count -gt 0) {
        Write-Host "Current Graph session is missing required scopes. Reconnecting..."
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null
    }
}

function Resolve-RepoRelativePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        if (-not (Test-Path -Path $PathValue)) {
            throw "JSON file not found: $PathValue"
        }
        return (Resolve-Path -Path $PathValue).Path
    }

    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
    $combined = Join-Path $repoRoot $PathValue

    if (-not (Test-Path -Path $combined)) {
        throw "JSON file not found: $combined"
    }

    return (Resolve-Path -Path $combined).Path
}

function ConvertTo-HashtableRecursive {
    param(
        [Parameter(Mandatory = $true)]
        $InputObject
    )

    if ($null -eq $InputObject) {
        return $null
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        $hash = @{}
        foreach ($key in $InputObject.Keys) {
            $hash[$key] = ConvertTo-HashtableRecursive -InputObject $InputObject[$key]
        }
        return $hash
    }

    if ($InputObject -is [System.Management.Automation.PSCustomObject]) {
        $hash = @{}
        foreach ($prop in $InputObject.PSObject.Properties) {
            $hash[$prop.Name] = ConvertTo-HashtableRecursive -InputObject $prop.Value
        }
        return $hash
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $array = @()
        foreach ($item in $InputObject) {
            $array += ,(ConvertTo-HashtableRecursive -InputObject $item)
        }
        return $array
    }

    return $InputObject
}

function Resolve-NamedLocations {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body,

        [Parameter(Mandatory = $true)]
        [array]$Locations
    )

    if (-not $Body.ContainsKey("conditions")) {
        return $Body
    }

    if (-not $Body["conditions"].ContainsKey("locations")) {
        return $Body
    }

    foreach ($type in @("includeLocations", "excludeLocations")) {
        if ($Body["conditions"]["locations"].ContainsKey($type)) {
            $resolved = @()

            foreach ($loc in $Body["conditions"]["locations"][$type]) {
                if ($loc -eq "All" -or $loc -eq "AllTrusted") {
                    $resolved += $loc
                }
                elseif ($loc -like "NAME:*") {
                    $name = $loc.Substring(5)
                    $match = $Locations |
                        Where-Object { $_.DisplayName -eq $name } |
                        Select-Object -First 1

                    if (-not $match) {
                        throw "Named location not found: $name"
                    }

                    $resolved += $match.Id
                }
                else {
                    $resolved += $loc
                }
            }

            $Body["conditions"]["locations"][$type] = $resolved
        }
    }

    return $Body
}

function Get-ExistingPolicyByDisplayName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName
    )

    $normalizedName = $DisplayName.Trim().ToLower()

    $matches = Get-MgIdentityConditionalAccessPolicy -All |
        Where-Object {
            $_.DisplayName -and $_.DisplayName.Trim().ToLower() -eq $normalizedName
        }

    if ($matches.Count -gt 1) {
        $ids = ($matches | Select-Object -ExpandProperty Id) -join ", "
        throw "Multiple policies found with displayName '$DisplayName'. Duplicate IDs: $ids. Remove duplicates before redeploying."
    }

    return ($matches | Select-Object -First 1)
}

# Main
Ensure-GraphReady

$resolvedJsonPath = Resolve-RepoRelativePath -PathValue $JsonPath
Write-Host "Using JSON file: $resolvedJsonPath"

try {
    $json = Get-Content -Path $resolvedJsonPath -Raw | ConvertFrom-Json
}
catch {
    throw "Failed to parse JSON file: $resolvedJsonPath"
}

$body = ConvertTo-HashtableRecursive -InputObject $json

if (-not $body.ContainsKey("displayName") -or [string]::IsNullOrWhiteSpace($body["displayName"])) {
    throw "displayName is required in the policy JSON."
}

$namedLocations = Get-MgIdentityConditionalAccessNamedLocation -All
$body = Resolve-NamedLocations -Body $body -Locations $namedLocations

Write-Host "Processing policy: $($body['displayName'])"

$existing = Get-ExistingPolicyByDisplayName -DisplayName $body["displayName"]

try {
    if ($existing) {
        Write-Host "Updating existing policy..."

        Update-MgIdentityConditionalAccessPolicy `
            -ConditionalAccessPolicyId $existing.Id `
            -BodyParameter $body `
            -ErrorAction Stop | Out-Null

        Write-Host "Updated: $($body['displayName'])"
        Write-Host "Policy ID: $($existing.Id)"
    }
    else {
        Write-Host "Creating new policy..."

        $result = New-MgIdentityConditionalAccessPolicy `
            -BodyParameter $body `
            -ErrorAction Stop

        Write-Host "Created: $($result.DisplayName)"
        Write-Host "Policy ID: $($result.Id)"
    }
}
catch {
    Write-Host "FAILED: $($body['displayName'])" -ForegroundColor Red
    throw
}
