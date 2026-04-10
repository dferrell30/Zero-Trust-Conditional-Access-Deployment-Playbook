<#
.SYNOPSIS
Bootstrap script for Zero Trust Conditional Access deployment.

.DESCRIPTION
- Unblocks files in the repo
- Installs/connects Microsoft Graph prerequisites
- Syncs named locations
- Deploys all Conditional Access policies
- Prints a verification summary
#>

[CmdletBinding()]
param(
    [switch]$SkipUnblock,
    [switch]$SkipNamedLocations,
    [switch]$SkipDeploy,
    [switch]$SkipVerify
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host $Name -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan

    & $Action
}

$repoRoot = Get-RepoRoot
Set-Location $repoRoot

$installScript       = Join-Path $repoRoot "scripts\deployment\install-prereqs.ps1"
$namedLocationScript = Join-Path $repoRoot "scripts\named-locations\create-named-locations.ps1"
$bulkDeployScript    = Join-Path $repoRoot "scripts\deployment\deploy-policies-bulk.ps1"

if (-not (Test-Path $installScript)) {
    throw "Missing file: $installScript"
}
if (-not (Test-Path $namedLocationScript)) {
    throw "Missing file: $namedLocationScript"
}
if (-not (Test-Path $bulkDeployScript)) {
    throw "Missing file: $bulkDeployScript"
}

Write-Host "Repo root: $repoRoot" -ForegroundColor Green

if (-not $SkipUnblock) {
    Invoke-Step -Name "Step 1: Unblocking downloaded files" -Action {
        Get-ChildItem -Path $repoRoot -Recurse -File | Unblock-File
        Write-Host "Files unblocked." -ForegroundColor Green
    }
}

Invoke-Step -Name "Step 2: Install prerequisites and connect to Graph" -Action {
    & $installScript
}

if (-not $SkipNamedLocations) {
    Invoke-Step -Name "Step 3: Create/update named locations" -Action {
        & $namedLocationScript
    }
}

if (-not $SkipDeploy) {
    Invoke-Step -Name "Step 4: Deploy Conditional Access policies" -Action {
        & $bulkDeployScript
    }
}

if (-not $SkipVerify) {
    Invoke-Step -Name "Step 5: Verify deployed policies" -Action {
        $policies = Get-MgIdentityConditionalAccessPolicy -All |
            Select-Object DisplayName, State |
            Sort-Object DisplayName

        $policies | Format-Table -AutoSize
    }
}

Write-Host ""
Write-Host "Bootstrap run complete." -ForegroundColor Green
