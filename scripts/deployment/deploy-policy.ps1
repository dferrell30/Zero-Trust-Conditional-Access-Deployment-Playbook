<#
.SYNOPSIS
Deploys a single Microsoft Entra Conditional Access policy from a JSON file.

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
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        throw "Microsoft.Graph is not installed. Run .\scripts\deployment\install-prereqs.ps1 first."
    }

    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    if (-not $ctx) {
        throw "Not connected to Microsoft Graph. Run .\scripts\deployment\install-prereqs.ps1 first."
    }

    $requiredScopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Directory.Read.All",
        "Application.Read.All"
    )

    $missingScopes = @()
    foreach ($scope in $requiredScopes) {
        if ($ctx.Scopes -notcontains $scope) {
            $missingScopes += $scope
        }
    }

    if ($missingScopes.Count -gt 0) {
        throw "Current Graph session is missing required scopes: $($missingScopes -join ', '). Run .\scripts\deployment\install-prereqs.ps1 again."
    }
}

function Resolve-RepoRelativePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return (Resolve-Path -Path $PathValue).Path
    }

    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
    $combined = Join-Path $repoRoot $PathValue

    if (-not (Test-Path $combined)) {
        throw "JSON file not found: $combined"
    }

    return (Resolve-Path -Path $combined).Path
}

Ensure-GraphReady

$resolvedJsonPath = Resolve-RepoRelativePath -PathValue $JsonPath
Write-Host "Using JSON file: $resolvedJsonPath"

$policyObject = Get-Content -Path $resolvedJsonPath -Raw | ConvertFrom-Json -Depth 100

if (-not $policyObject.displayName) {
    throw "JSON file is missing displayName."
}

Write-Host "Creating policy: $($policyObject.displayName)"
$result = New-MgIdentityConditionalAccessPolicy -BodyParameter $policyObject

Write-Host "Policy created successfully."
Write-Host "Display Name: $($result.DisplayName)"
Write-Host "Policy ID:    $($result.Id)"
