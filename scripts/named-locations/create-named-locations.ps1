<#
.SYNOPSIS
Creates or updates Microsoft Entra named locations from a config file.
#>

[CmdletBinding()]
param(
    [string]$ConfigPath = ""
)

$ErrorActionPreference = "Stop"

function Ensure-GraphReady {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        throw "Microsoft.Graph is not installed. Run .\scripts\deployment\install-prereqs.ps1 first."
    }

    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $requiredScopes = @("Policy.ReadWrite.ConditionalAccess","Policy.Read.All")
    $ctx = Get-MgContext -ErrorAction SilentlyContinue

    if (-not $ctx) {
        Write-Host "Connecting to Microsoft Graph..."
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null
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
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null
    }
}

function Resolve-ConfigPath {
    param([string]$PathValue)

    if ([string]::IsNullOrWhiteSpace($PathValue)) {
        return (Join-Path $PSScriptRoot "locations-config.json")
    }

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return (Resolve-Path $PathValue).Path
    }

    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
    return (Resolve-Path (Join-Path $repoRoot $PathValue)).Path
}

function ConvertTo-IpRangeObject {
    param([string]$Cidr)

    if ($Cidr -match ":") {
        return @{
            "@odata.type" = "#microsoft.graph.iPv6CidrRange"
            cidrAddress   = $Cidr
        }
    }

    return @{
        "@odata.type" = "#microsoft.graph.iPv4CidrRange"
        cidrAddress   = $Cidr
    }
}

function Get-NamedLocationByDisplayName {
    param(
        [string]$DisplayName,
        [array]$AllLocations
    )

    return $AllLocations | Where-Object { $_.DisplayName -eq $DisplayName } | Select-Object -First 1
}

Ensure-GraphReady

$configPathResolved = Resolve-ConfigPath -PathValue $ConfigPath
Write-Host "Using config: $configPathResolved"

$config = Get-Content $configPathResolved -Raw | ConvertFrom-Json
$existingLocations = Get-MgIdentityConditionalAccessNamedLocation -All

foreach ($loc in $config.ipLocations) {
    $existing = Get-NamedLocationByDisplayName -DisplayName $loc.name -AllLocations $existingLocations

    $body = @{
        "@odata.type" = "#microsoft.graph.ipNamedLocation"
        displayName   = $loc.name
        isTrusted     = [bool]$loc.isTrusted
        ipRanges      = @()
    }

    foreach ($range in $loc.ipRanges) {
        $body.ipRanges += (ConvertTo-IpRangeObject -Cidr $range)
    }

    if ($existing) {
        Write-Host "Updating IP named location: $($loc.name)"
        Update-MgIdentityConditionalAccessNamedLocation -NamedLocationId $existing.Id -BodyParameter $body | Out-Null
    }
    else {
        Write-Host "Creating IP named location: $($loc.name)"
        New-MgIdentityConditionalAccessNamedLocation -BodyParameter $body | Out-Null
    }
}

$existingLocations = Get-MgIdentityConditionalAccessNamedLocation -All

foreach ($geo in $config.geoLocations) {
    $existing = Get-NamedLocationByDisplayName -DisplayName $geo.name -AllLocations $existingLocations

    $body = @{
        "@odata.type" = "#microsoft.graph.countryNamedLocation"
        displayName   = $geo.name
        countriesAndRegions = @($geo.countries)
        includeUnknownCountriesAndRegions = [bool]$geo.includeUnknownCountriesAndRegions
    }

    if ($existing) {
        Write-Host "Updating country named location: $($geo.name)"
        Update-MgIdentityConditionalAccessNamedLocation -NamedLocationId $existing.Id -BodyParameter $body | Out-Null
    }
    else {
        Write-Host "Creating country named location: $($geo.name)"
        New-MgIdentityConditionalAccessNamedLocation -BodyParameter $body | Out-Null
    }
}

Write-Host "Named location sync complete."
