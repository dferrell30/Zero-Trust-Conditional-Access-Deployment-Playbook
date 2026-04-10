```powershell
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

# -----------------------------
# Graph Connection
# -----------------------------
function Ensure-GraphReady {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $scopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Policy.Read.All",
        "Directory.Read.All",
        "Application.Read.All"
    )

    if (-not (Get-MgContext)) {
        Connect-MgGraph -Scopes $scopes -NoWelcome | Out-Null
    }
}

# -----------------------------
# Convert JSON → Hashtable
# -----------------------------
function ConvertTo-HashtableRecursive {
    param($InputObject)

    if ($null -eq $InputObject) { return $null }

    if ($InputObject -is [System.Management.Automation.PSCustomObject]) {
        $hash = @{}
        foreach ($prop in $InputObject.PSObject.Properties) {
            $hash[$prop.Name] = ConvertTo-HashtableRecursive $prop.Value
        }
        return $hash
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $array = @()
        foreach ($item in $InputObject) {
            $array += ,(ConvertTo-HashtableRecursive $item)
        }
        return $array
    }

    return $InputObject
}

# -----------------------------
# Resolve Named Locations
# -----------------------------
function Resolve-NamedLocations {
    param(
        [hashtable]$Body,
        [array]$Locations
    )

    if (-not $Body.conditions.locations) { return $Body }

    foreach ($type in @("includeLocations", "excludeLocations")) {
        if ($Body.conditions.locations.$type) {
            $resolved = @()

            foreach ($loc in $Body.conditions.locations.$type) {

                if ($loc -like "NAME:*") {
                    $name = $loc.Substring(5)
                    $match = $Locations | Where-Object { $_.DisplayName -eq $name }

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

# -----------------------------
# MAIN
# -----------------------------
Ensure-GraphReady

$path = Resolve-Path $JsonPath
Write-Host "Using: $path"

$json = Get-Content $path -Raw | ConvertFrom-Json -Depth 100
$body = ConvertTo-HashtableRecursive $json

$locations = Get-MgIdentityConditionalAccessNamedLocation -All
$body = Resolve-NamedLocations -Body $body -Locations $locations

if (-not $body.displayName) {
    throw "displayName is required"
}

Write-Host "Processing policy: $($body.displayName)"

# -----------------------------
# Check Existing Policy
# -----------------------------
$existing = Get-MgIdentityConditionalAccessPolicy -All |
    Where-Object { $_.DisplayName -eq $body.displayName }

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
```
