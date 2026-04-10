<#
.SYNOPSIS
Exports Microsoft Entra Conditional Access policies and named locations to JSON files.

.DESCRIPTION
- Connects to Microsoft Graph if needed
- Exports each Conditional Access policy to its own JSON file
- Exports each named location to its own JSON file
- Creates index files for easy review
- Intended for backup and Git-based tracking

.REQUIREMENTS
- Microsoft.Graph PowerShell module
- Module: Microsoft.Graph.Identity.SignIns
- Scope: Policy.Read.All
#>

[CmdletBinding()]
param(
    [string]$OutputRoot = "",
    [switch]$UseTimestampFolder
)

$ErrorActionPreference = "Stop"

function Ensure-GraphReady {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        throw "Microsoft.Graph is not installed. Run .\scripts\deployment\install-prereqs.ps1 first."
    }

    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $requiredScopes = @("Policy.Read.All")
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

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
}

function Ensure-Directory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }
}

function New-SafeFileName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $safe = $Name
    foreach ($char in [System.IO.Path]::GetInvalidFileNameChars()) {
        $safe = $safe.Replace($char, "_")
    }

    $safe = ($safe -replace '\s+', ' ').Trim()

    if ([string]::IsNullOrWhiteSpace($safe)) {
        $safe = "unnamed"
    }

    return $safe
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)]
        $Object,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $Object | ConvertTo-Json -Depth 100 | Set-Content -Path $Path -Encoding UTF8
}

function Export-Policies {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetFolder
    )

    Ensure-Directory -Path $TargetFolder

    Write-Host "Exporting Conditional Access policies..."
    $policies = Get-MgIdentityConditionalAccessPolicy -All
    $index = @()

    foreach ($policy in $policies) {
        $safeName = New-SafeFileName -Name $policy.DisplayName
        $fileName = "{0}__{1}.json" -f $safeName, $policy.Id
        $filePath = Join-Path $TargetFolder $fileName

        Write-JsonFile -Object $policy -Path $filePath

        $index += [pscustomobject]@{
            id          = $policy.Id
            displayName = $policy.DisplayName
            state       = $policy.State
            fileName    = $fileName
        }
    }

    Write-JsonFile -Object $index -Path (Join-Path $TargetFolder "_index.json")
    Write-Host "Conditional Access policies exported: $($policies.Count)"
}

function Export-NamedLocations {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetFolder
    )

    Ensure-Directory -Path $TargetFolder

    Write-Host "Exporting named locations..."
    $locations = Get-MgIdentityConditionalAccessNamedLocation -All
    $index = @()

    foreach ($location in $locations) {
        $safeName = New-SafeFileName -Name $location.DisplayName
        $fileName = "{0}__{1}.json" -f $safeName, $location.Id
        $filePath = Join-Path $TargetFolder $fileName

        Write-JsonFile -Object $location -Path $filePath

        $index += [pscustomobject]@{
            id          = $location.Id
            displayName = $location.DisplayName
            type        = $location.AdditionalProperties.'@odata.type'
            fileName    = $fileName
        }
    }

    Write-JsonFile -Object $index -Path (Join-Path $TargetFolder "_index.json")
    Write-Host "Named locations exported: $($locations.Count)"
}

Ensure-GraphReady

$repoRoot = Get-RepoRoot

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $repoRoot "exports\raw"
}

if ($UseTimestampFolder) {
    $stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $OutputRoot = Join-Path $OutputRoot $stamp
}

$policyFolder   = Join-Path $OutputRoot "conditional-access-policies"
$locationFolder = Join-Path $OutputRoot "named-locations"

Ensure-Directory -Path $OutputRoot
Export-Policies -TargetFolder $policyFolder
Export-NamedLocations -TargetFolder $locationFolder

Write-Host ""
Write-Host "Backup export complete."
Write-Host "Output folder: $OutputRoot"
