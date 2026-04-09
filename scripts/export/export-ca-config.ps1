<#
.SYNOPSIS
Exports Microsoft Entra Conditional Access named locations and Conditional Access policies to JSON files.

.DESCRIPTION
- Connects to Microsoft Graph if needed
- Exports each named location to its own JSON file
- Exports each Conditional Access policy to its own JSON file
- Creates index files for easier browsing
- Good for GitHub backup, documentation, and change tracking

.REQUIREMENTS
- Microsoft.Graph PowerShell module
- Graph scopes:
  Policy.Read.All

.NOTES
- This script exports the objects as returned by Microsoft Graph.
- These exports are great for backup/review/source control.
- For re-import, you may want a separate "normalized import" script later so you can strip read-only properties.
#>

[CmdletBinding()]
param(
    [string]$OutputPath = ".\exports",
    [switch]$IncludeTimestampFolder
)

$ErrorActionPreference = "Stop"

function Ensure-GraphModule {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.SignIns)) {
        Write-Host "Microsoft.Graph.Identity.SignIns not found. Installing Microsoft.Graph..."
        Install-Module Microsoft.Graph -Scope CurrentUser -Force
    }
}

function Connect-ToGraphIfNeeded {
    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    if (-not $ctx) {
        Write-Host "Connecting to Microsoft Graph..."
        Connect-MgGraph -Scopes "Policy.Read.All" | Out-Null
    }
    else {
        Write-Host "Already connected to Microsoft Graph as $($ctx.Account)"
    }
}

function New-SafeFileName {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    $safe = $Name

    foreach ($char in $invalidChars) {
        $safe = $safe.Replace($char, "_")
    }

    $safe = $safe -replace '\s+', ' '
    $safe = $safe.Trim()

    if ([string]::IsNullOrWhiteSpace($safe)) {
        $safe = "unnamed"
    }

    return $safe
}

function Ensure-Directory {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory)]
        $Object,

        [Parameter(Mandatory)]
        [string]$Path
    )

    $Object | ConvertTo-Json -Depth 100 | Set-Content -Path $Path -Encoding UTF8
}

function Export-NamedLocations {
    param(
        [Parameter(Mandatory)]
        [string]$TargetFolder
    )

    Write-Host "Exporting named locations..."
    Ensure-Directory -Path $TargetFolder

    $namedLocations = Get-MgIdentityConditionalAccessNamedLocation -All
    $index = @()

    foreach ($item in $namedLocations) {
        $safeName = New-SafeFileName -Name $item.DisplayName
        $fileName = "{0}__{1}.json" -f $safeName, $item.Id
        $filePath = Join-Path $TargetFolder $fileName

        Write-JsonFile -Object $item -Path $filePath

        $index += [pscustomobject]@{
            id          = $item.Id
            displayName = $item.DisplayName
            fileName    = $fileName
            type        = $item.AdditionalProperties.'@odata.type'
            createdDate = $item.CreatedDateTime
            modifiedDate= $item.ModifiedDateTime
        }
    }

    Write-JsonFile -Object $index -Path (Join-Path $TargetFolder "_index.json")
    Write-Host ("Named locations exported: {0}" -f $namedLocations.Count)
}

function Export-ConditionalAccessPolicies {
    param(
        [Parameter(Mandatory)]
        [string]$TargetFolder
    )

    Write-Host "Exporting Conditional Access policies..."
    Ensure-Directory -Path $TargetFolder

    $policies = Get-MgIdentityConditionalAccessPolicy -All
    $index = @()

    foreach ($item in $policies) {
        $safeName = New-SafeFileName -Name $item.DisplayName
        $fileName = "{0}__{1}.json" -f $safeName, $item.Id
        $filePath = Join-Path $TargetFolder $fileName

        Write-JsonFile -Object $item -Path $filePath

        $index += [pscustomobject]@{
            id          = $item.Id
            displayName = $item.DisplayName
            fileName    = $fileName
            state       = $item.State
            createdDate = $item.CreatedDateTime
            modifiedDate= $item.ModifiedDateTime
        }
    }

    Write-JsonFile -Object $index -Path (Join-Path $TargetFolder "_index.json")
    Write-Host ("Conditional Access policies exported: {0}" -f $policies.Count)
}

# Main
Ensure-GraphModule
Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop
Connect-ToGraphIfNeeded

$basePath = $OutputPath

if ($IncludeTimestampFolder) {
    $stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $basePath = Join-Path $OutputPath $stamp
}

$namedLocationPath = Join-Path $basePath "named-locations"
$policyPath        = Join-Path $basePath "conditional-access-policies"

Ensure-Directory -Path $basePath
Export-NamedLocations -TargetFolder $namedLocationPath
Export-ConditionalAccessPolicies -TargetFolder $policyPath

Write-Host ""
Write-Host "Export complete."
Write-Host "Base folder: $basePath"
