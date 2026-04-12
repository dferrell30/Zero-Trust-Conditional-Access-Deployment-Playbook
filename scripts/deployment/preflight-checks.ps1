<#
.SYNOPSIS
Runs preflight validation checks against Conditional Access policy JSON files.

.DESCRIPTION
- Scans all policy.json files under the policies folder
- Detects common design and deployment issues before deployment
- Fails on blocking errors
- Warns on risky but non-blocking conditions
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
}

function Add-Issue {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Error","Warning")]
        [string]$Severity,

        [Parameter(Mandatory = $true)]
        [string]$File,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $script:Issues += [pscustomobject]@{
        Severity = $Severity
        File     = $File
        Message  = $Message
    }
}

function Get-BuiltInControls {
    param($Policy)

    if ($null -eq $Policy.grantControls) { return @() }
    if ($null -eq $Policy.grantControls.builtInControls) { return @() }

    return @($Policy.grantControls.builtInControls)
}

function Test-PolicyShape {
    param(
        [Parameter(Mandatory = $true)]$Policy,
        [Parameter(Mandatory = $true)][string]$File
    )

    if ([string]::IsNullOrWhiteSpace($Policy.displayName)) {
        Add-Issue -Severity Error -File $File -Message "Missing displayName."
    }

    if ([string]::IsNullOrWhiteSpace($Policy.state)) {
        Add-Issue -Severity Error -File $File -Message "Missing state."
    }

    if ($null -eq $Policy.conditions) {
        Add-Issue -Severity Error -File $File -Message "Missing conditions block."
    }

    $controls = Get-BuiltInControls -Policy $Policy
    $hasSessionControls = $null -ne $Policy.sessionControls

    if (-not $hasSessionControls -and $controls.Count -eq 0) {
        Add-Issue -Severity Warning -File $File -Message "No builtInControls found. This may be valid only for session-control-only policies."
    }
}

function Test-RiskPolicies {
    param(
        [Parameter(Mandatory = $true)]$Policy,
        [Parameter(Mandatory = $true)][string]$File
    )

    $controls = Get-BuiltInControls -Policy $Policy
    $operator = $Policy.grantControls.operator

    if ($null -ne $Policy.conditions.userRiskLevels) {
        if ($controls -contains "passwordChange") {
            if (-not ($controls -contains "mfa")) {
                Add-Issue -Severity Error -File $File -Message "User risk policy uses passwordChange without mfa."
            }

            if ($operator -ne "AND") {
                Add-Issue -Severity Error -File $File -Message "User risk policy using passwordChange must use operator AND."
            }
        }
    }
}

function Test-LocationPolicies {
    param(
        [Parameter(Mandatory = $true)]$Policy,
        [Parameter(Mandatory = $true)][string]$File
    )

    $controls = Get-BuiltInControls -Policy $Policy
    if (-not ($controls -contains "block")) { return }

    if ($null -eq $Policy.conditions.locations) { return }

    $includeLocations = @($Policy.conditions.locations.includeLocations)
    $excludeLocations = @($Policy.conditions.locations.excludeLocations)

    $includesAll = $includeLocations -contains "All"
    $hasTrustedExclusion = ($excludeLocations -contains "AllTrusted") -or ($excludeLocations | Where-Object { $_ -like "NAME:*" }).Count -gt 0

    if ($includesAll -and -not $hasTrustedExclusion) {
        Add-Issue -Severity Error -File $File -Message "Location block policy includes All locations without trusted exclusions. This risks a BlockEveryone policy."
    }
}

function Test-BreakGlassWarnings {
    param(
        [Parameter(Mandatory = $true)]$Policy,
        [Parameter(Mandatory = $true)][string]$File
    )

    if ($null -eq $Policy.conditions.users) { return }

    $includeUsers = @($Policy.conditions.users.includeUsers)
    $excludeUsers = @($Policy.conditions.users.excludeUsers)

    if ($includeUsers -contains "All" -and $excludeUsers.Count -eq 0) {
        Add-Issue -Severity Warning -File $File -Message "Policy targets All users with no excludeUsers configured. Add break-glass exclusions before production enforcement."
    }

    if ($excludeUsers -contains "<BREAK_GLASS_OBJECT_ID>") {
        Add-Issue -Severity Error -File $File -Message "Placeholder <BREAK_GLASS_OBJECT_ID> is still present."
    }
}

function Test-DisplayNameDuplicates {
    param(
        [Parameter(Mandatory = $true)][array]$Entries
    )

    $groups = $Entries | Group-Object NormalizedDisplayName | Where-Object { $_.Count -gt 1 }

    foreach ($group in $groups) {
        $files = ($group.Group | Select-Object -ExpandProperty File) -join "; "
        Add-Issue -Severity Error -File $files -Message "Duplicate displayName detected in repo JSON: '$($group.Group[0].DisplayName)'."
    }
}

function Test-CompliantDeviceCount {
    param(
        [Parameter(Mandatory = $true)][array]$Entries
    )

    $compliantFiles = $Entries | Where-Object { $_.BuiltInControls -contains "compliantDevice" }

    if ($compliantFiles.Count -gt 1) {
        $files = ($compliantFiles | Select-Object -ExpandProperty File) -join "; "
        Add-Issue -Severity Error -File $files -Message "More than one policy uses compliantDevice. Keep device compliance isolated to the dedicated device-compliance policy unless intentionally segmented."
    }
}

function Test-PlaceholderNamedLocations {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot
    )

    $configPath = Join-Path $RepoRoot "scripts\named-locations\locations-config.json"
    if (-not (Test-Path $configPath)) { return }

    try {
        $config = Get-Content $configPath -Raw | ConvertFrom-Json
    }
    catch {
        Add-Issue -Severity Error -File $configPath -Message "Could not parse locations-config.json."
        return
    }

    foreach ($ipLoc in @($config.ipLocations)) {
        if ($null -eq $ipLoc.ipRanges -or @($ipLoc.ipRanges).Count -eq 0) {
            Add-Issue -Severity Warning -File $configPath -Message "IP named location '$($ipLoc.name)' has no ipRanges configured."
        }

        foreach ($range in @($ipLoc.ipRanges)) {
            if ($range -like "<REPLACE*") {
                Add-Issue -Severity Error -File $configPath -Message "Named location '$($ipLoc.name)' still contains placeholder IP range '$range'."
            }

            if ($range -eq "203.0.113.10/32" -or $range -eq "198.51.100.0/24") {
                Add-Issue -Severity Warning -File $configPath -Message "Named location '$($ipLoc.name)' contains documentation/test IP range '$range'. Replace with real IPs before production."
            }
        }
    }
}

# Main
$Issues = @()
$repoRoot = Get-RepoRoot
$policiesRoot = Join-Path $repoRoot "policies"

if (-not (Test-Path $policiesRoot)) {
    throw "Policies folder not found: $policiesRoot"
}

$policyFiles = Get-ChildItem -Path $policiesRoot -Filter "policy.json" -Recurse -File | Sort-Object FullName

if (-not $policyFiles -or $policyFiles.Count -eq 0) {
    throw "No policy.json files found under: $policiesRoot"
}

$entries = @()

foreach ($file in $policyFiles) {
    try {
        $policy = Get-Content $file.FullName -Raw | ConvertFrom-Json
    }
    catch {
        Add-Issue -Severity Error -File $file.FullName -Message "Invalid JSON."
        continue
    }

    Test-PolicyShape -Policy $policy -File $file.FullName
    Test-RiskPolicies -Policy $policy -File $file.FullName
    Test-LocationPolicies -Policy $policy -File $file.FullName
    Test-BreakGlassWarnings -Policy $policy -File $file.FullName

    $displayName = [string]$policy.displayName
    $normalizedDisplayName = $displayName.Trim().ToLower()
    $controls = Get-BuiltInControls -Policy $policy

    $entries += [pscustomobject]@{
        File                  = $file.FullName
        DisplayName           = $displayName
        NormalizedDisplayName = $normalizedDisplayName
        BuiltInControls       = $controls
    }
}

Test-DisplayNameDuplicates -Entries $entries
Test-CompliantDeviceCount -Entries $entries
Test-PlaceholderNamedLocations -RepoRoot $repoRoot

$errors = $Issues | Where-Object { $_.Severity -eq "Error" }
$warnings = $Issues | Where-Object { $_.Severity -eq "Warning" }

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Preflight Check Results" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "Warnings:" -ForegroundColor Yellow
    $warnings | Format-Table Severity, File, Message -Wrap -AutoSize
}

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "Errors:" -ForegroundColor Red
    $errors | Format-Table Severity, File, Message -Wrap -AutoSize
    throw "Preflight checks failed with $($errors.Count) error(s)."
}

if ($Issues.Count -eq 0) {
    Write-Host "No issues found." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "Preflight checks passed with warnings only." -ForegroundColor Yellow
}
