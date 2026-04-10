<#
.SYNOPSIS
Deploys (create/update) a Conditional Access policy from JSON.

.DESCRIPTION
- Resolves named locations by NAME:<displayName>
- Converts JSON to proper Graph format
- Creates policy if not exists
- Updates policy if it already exists
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$JsonPath
)

$ErrorActionPreference = "Stop"

function Ensure-GraphReady {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $scopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Policy.Read.All",
        "Directory.Read.All",
        "Application.Read.All"
    )

    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    if (-not $ctx) {
        Connect-MgGraph -Scopes $scopes -NoWelcome | Out-Null
        return
    }

    $missingScopes = @()
    foreach ($scope in $scopes) {
        if ($ctx.Scopes -notcontains $scope) {
            $missingScopes += $scope
        }
    }

    if ($missingScopes.Count -gt 0) {
        Connect-MgGraph -Scopes $scopes -NoWelcome | Out-Null
    }
}

function Resolve-RepoRelativePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        if (-not (Test-Path $PathValue)) {
            throw "JSON file not found: $PathValue"
        }
        return (Resolve-Path -Path $PathValue).Path
    }

    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
    $combined = Join-Path $repoRoot $PathValue

    if (-not (Test-Path $combined)) {
        throw "JSON file not found: $combined"
    }

    return (Resolve-Path -Path $combined).Path
}

function ConvertTo-HashtableRecursive {
    param($InputObject)

    if ($null -eq $InputObject) { return $null }

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
        [hashtable]$Body,
        [array]$Locations
    )

    if (-not $Body.ContainsKey("conditions")) { return $Body }
    if (-not $Body.conditions.ContainsKey("locations")) { return $Body }

    foreach ($type in @("includeLocations", "excludeLocations")) {
        if ($Body.conditions.locations.$type) {
            $resolved = @()

            foreach ($loc in $Body.conditions.locations.$type) {
                if ($loc -eq "All" -or $loc -eq "AllTrusted") {
                    $resolved += $loc
                }
                elseif ($loc -like "NAME:*") {
                    $name = $loc.Substring(5)
                    $match = $Locations | Where-Object { $_.DisplayName -eq $name } | Select-Object -First 1

                    if (-not $match) {
                        throw "Named location not found: $name"
                    }

                    $resolved += $match.Id
                }
                else {
                    $resolved += $loc
                }
            }

            $Body.conditions.locations.$type = $resolved
        }
    }

    return $Body
}

Ensure-GraphReady

$path = Resolve-RepoRelativePath -PathValue $JsonPath
Write-Host "Using: $path"

$json = Get-Content $path -Raw | ConvertFrom-Json -Depth 100
$body = ConvertTo-HashtableRecursive -InputObject $json

$locations = Get-MgIdentityConditionalAccessNamedLocation -All
$body = Resolve-NamedLocations -Body $body -Locations $locations

if (-not $body.displayName) {
    throw "displayName is required"
}

Write-Host "Processing policy: $($body.displayName)"

$existing = Get-MgIdentityConditionalAccessPolicy -All |
    Where-Object { $_.DisplayName -eq $body.displayName } |
    Select-Object -First 1

try {
    if ($existing) {
        Write-Host "Updating existing policy..."

        Update-MgIdentityConditionalAccessPolicy `
            -ConditionalAccessPolicyId $existing.Id `
            -BodyParameter $body `
            -ErrorAction Stop

        Write-Host "Updated: $($body.displayName)"
    }
    else {
        Write-Host "Creating new policy..."

        $result = New-MgIdentityConditionalAccessPolicy `
            -BodyParameter $body `
            -ErrorAction Stop

        Write-Host "Created: $($result.DisplayName)"
    }
}
catch {
    Write-Host "FAILED: $($body.displayName)" -ForegroundColor Red
    throw
}
