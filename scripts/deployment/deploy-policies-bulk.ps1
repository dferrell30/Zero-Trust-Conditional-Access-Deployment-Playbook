<#
.SYNOPSIS
Deploys all Conditional Access policy JSON files in the repo.

.DESCRIPTION
- Finds every policy.json under .\policies
- Deploys them one at a time
- Continues through the list and summarizes failures
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$policiesRoot = Join-Path $repoRoot "policies"
$deployScript = Join-Path $PSScriptRoot "deploy-policy.ps1"

if (-not (Test-Path $policiesRoot)) {
    throw "Policies folder not found: $policiesRoot"
}

if (-not (Test-Path $deployScript)) {
    throw "deploy-policy.ps1 not found: $deployScript"
}

$jsonFiles = Get-ChildItem -Path $policiesRoot -Filter "policy.json" -Recurse -File | Sort-Object FullName

if (-not $jsonFiles -or $jsonFiles.Count -eq 0) {
    throw "No policy.json files found under: $policiesRoot"
}

$failures = @()

Write-Host "Found $($jsonFiles.Count) policy file(s)."

foreach ($file in $jsonFiles) {
    Write-Host ""
    Write-Host "=================================================="
    Write-Host "Deploying: $($file.FullName)"
    Write-Host "=================================================="

    try {
        & $deployScript -JsonPath $file.FullName
    }
    catch {
        Write-Host "FAILED: $($file.FullName)"
        Write-Host $_.Exception.Message
        $failures += [pscustomobject]@{
            File  = $file.FullName
            Error = $_.Exception.Message
        }
    }
}

Write-Host ""
Write-Host "Deployment run complete."

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "The following deployments failed:"
    $failures | Format-Table -AutoSize
    exit 1
}
else {
    Write-Host "All policies deployed successfully."
}
