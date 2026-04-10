<#
.SYNOPSIS
Deploys a single Microsoft Entra Conditional Access policy from a JSON file.
Automatically resolves named locations referenced as NAME:<displayName>.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$JsonPath
)

$ErrorActionPreference = "Stop"

function Ensure-GraphReady {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        throw "Microsoft.Graph is not installed. Run .\scripts\deployment\install-prereqs.ps1 first."
    }

    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $requiredScopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Directory.Read.All",
        "Application.Read.All",
        "Policy.Read.All"
    )

    $ctx = Get-MgContext -ErrorAction SilentlyContinue

    if (-not $ctx) {
        Write-Host "Not connected to Microsoft Graph. Connecting now..."
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null
        $ctx = Get-MgContext
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
    param([string]$PathValue)

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

function Resolve-NamedLocationReference {
    param(
        [string]$Value,
        [array]$AllNamedLocations
    )

    if ($Value -eq "All" -or $Value -eq "AllTrusted") {
        return $Value
    }

    if ($Value -like "NAME:*") {
        $displayName = $Value.Substring(5)
        $match = $AllNamedLocations | Where-Object { $_.DisplayName -eq $displayName } | Select-Object -First 1

        if (-not $match) {
            throw "Named location not found: $displayName"
        }

        return $match.Id
    }

    return $Value
}

function Resolve-LocationReferencesInPolicy {
    param(
        [hashtable]$PolicyBody,
        [array]$AllNamedLocations
    )

    if (-not $PolicyBody.ContainsKey("conditions")) { return $PolicyBody }
    if (-not $PolicyBody.conditions.ContainsKey("locations")) { return $PolicyBody }

    if ($PolicyBody.conditions.locations.ContainsKey("includeLocations")) {
        $resolved = @()
        foreach ($loc in $PolicyBody.conditions.locations.includeLocations) {
            $resolved += (Resolve-NamedLocationReference -Value $loc -AllNamedLocations $AllNamedLocations)
        }
        $PolicyBody.conditions.locations.includeLocations = $resolved
    }

    if ($PolicyBody.conditions.locations.ContainsKey("excludeLocations")) {
        $resolved = @()
        foreach ($loc in $PolicyBody.conditions.locations.excludeLocations) {
            $resolved += (Resolve-NamedLocationReference -Value $loc -AllNamedLocations $AllNamedLocations)
        }
        $PolicyBody.conditions.locations.excludeLocations = $resolved
    }

    return $PolicyBody
}

Ensure-GraphReady

$resolvedJsonPath = Resolve-RepoRelativePath -PathValue $JsonPath
Write-Host "Using JSON file: $resolvedJsonPath"

$rawJson = Get-Content -Path $resolvedJsonPath -Raw
$policyObject = $rawJson | ConvertFrom-Json -Depth 100
$body = ConvertTo-HashtableRecursive -InputObject $policyObject

$namedLocations = Get-MgIdentityConditionalAccessNamedLocation -All
$body = Resolve-LocationReferencesInPolicy -PolicyBody $body -AllNamedLocations $namedLocations

if (-not $body.displayName) {
    throw "JSON file is missing displayName."
}

Write-Host "Creating policy: $($body.displayName)"

try {
    $result = New-MgIdentityConditionalAccessPolicy -BodyParameter $body -ErrorAction Stop
    Write-Host "Policy created successfully."
    Write-Host "Display Name: $($result.DisplayName)"
    Write-Host "Policy ID:    $($result.Id)"
}
catch {
    Write-Host "Policy creation failed." -ForegroundColor Red
    throw
}
