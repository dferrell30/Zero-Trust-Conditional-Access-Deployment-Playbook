<#
.SYNOPSIS
Deploy a single Microsoft Entra Conditional Access policy from a JSON file.

.DESCRIPTION
- Reads a policy JSON file from disk
- Connects to Microsoft Graph if needed
- Creates the Conditional Access policy
- Intended to be called by per-policy deploy.ps1 scripts

.REQUIREMENTS
- Microsoft.Graph PowerShell module
- Graph scopes:
  Policy.ReadWrite.ConditionalAccess
  Directory.Read.All
  Application.Read.All
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Ensure-GraphModule {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.SignIns)) {
        Write-Host "Microsoft.Graph.Identity.SignIns not found. Installing Microsoft.Graph..."
        Install-Module Microsoft.Graph -Scope CurrentUser -Force
    }

    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop
}

function Connect-ToGraphIfNeeded {
    $requiredScopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Directory.Read.All",
        "Application.Read.All"
    )

    $ctx = Get-MgContext -ErrorAction SilentlyContinue

    if (-not $ctx) {
        Write-Host "Connecting to Microsoft Graph..."
        Connect-MgGraph -Scopes $requiredScopes | Out-Null
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
        Connect-MgGraph -Scopes $requiredScopes | Out-Null
    }
    else {
        Write-Host "Already connected to Microsoft Graph as $($ctx.Account)"
    }
}

function Resolve-PolicyJsonPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$JsonPath
    )

    if (-not (Test-Path -Path $JsonPath)) {
        throw "Policy JSON file not found: $JsonPath"
    }

    return (Resolve-Path -Path $JsonPath).Path
}

function Get-PolicyBodyFromJson {
    param(
        [Parameter(Mandatory = $true)]
        [string]$JsonPath
    )

    $resolvedPath = Resolve-PolicyJsonPath -JsonPath $JsonPath
    $rawJson = Get-Content -Path $resolvedPath -Raw

    if ([string]::IsNullOrWhiteSpace($rawJson)) {
        throw "Policy JSON file is empty: $resolvedPath"
    }

    return ($rawJson | ConvertFrom-Json -Depth 100)
}

function Test-ExistingPolicyByName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName
    )

    $existing = Get-MgIdentityConditionalAccessPolicy -All |
        Where-Object { $_.DisplayName -eq $DisplayName } |
        Select-Object -First 1

    return $existing
}

function New-ZTConditionalAccessPolicy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$JsonPath,

        [switch]$SkipIfExists
    )

    Ensure-GraphModule
    Connect-ToGraphIfNeeded

    Write-Host "Preparing to deploy policy: $DisplayName"

    $existing = Test-ExistingPolicyByName -DisplayName $DisplayName
    if ($existing) {
        if ($SkipIfExists) {
            Write-Host "Policy already exists. Skipping: $DisplayName"
            return $existing
        }

        throw "A Conditional Access policy with this display name already exists: $DisplayName"
    }

    $policyBody = Get-PolicyBodyFromJson -JsonPath $JsonPath

    Write-Host "Creating Conditional Access policy..."
    $createdPolicy = New-MgIdentityConditionalAccessPolicy -BodyParameter $policyBody

    Write-Host "Policy created successfully."
    Write-Host "Display Name: $($createdPolicy.DisplayName)"
    Write-Host "Policy Id:    $($createdPolicy.Id)"

    return $createdPolicy
}
