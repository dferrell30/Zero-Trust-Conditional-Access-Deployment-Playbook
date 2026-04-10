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

    $requiredScopes = @(
        "Policy.ReadWrite.ConditionalAccess",
        "Directory.Read.All",
        "Application.Read.All"
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

Ensure-GraphReady

$resolvedJsonPath = Resolve-RepoRelativePath -PathValue $JsonPath
Write-Host "Using JSON file: $resolvedJsonPath"

$rawJson = Get-Content -Path $resolvedJsonPath -Raw
$policyObject = $rawJson | ConvertFrom-Json -Depth 100
$body = ConvertTo-HashtableRecursive -InputObject $policyObject

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
