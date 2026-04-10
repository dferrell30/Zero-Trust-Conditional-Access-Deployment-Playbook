<#
.SYNOPSIS
Installs required PowerShell modules and connects to Microsoft Graph.

.DESCRIPTION
- Installs Microsoft.Graph if missing
- Imports Microsoft.Graph.Identity.SignIns
- Connects to Microsoft Graph with required scopes
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "Checking for Microsoft Graph PowerShell module..."

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Installing Microsoft.Graph for current user..."
    Install-Module Microsoft.Graph -Scope CurrentUser -Force -AllowClobber
}

Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

$requiredScopes = @(
    "Policy.ReadWrite.ConditionalAccess",
    "Directory.Read.All",
    "Application.Read.All"
)

Write-Host "Connecting to Microsoft Graph..."
Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null

$ctx = Get-MgContext
Write-Host "Connected to Graph as: $($ctx.Account)"
Write-Host "Tenant ID: $($ctx.TenantId)"
Write-Host "Scopes: $($ctx.Scopes -join ', ')"
