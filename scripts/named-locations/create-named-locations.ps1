<#
.SYNOPSIS
Creates Microsoft Entra Named Locations (IP + Geo-based)

.DESCRIPTION
- Creates trusted IP-based locations
- Creates country-based locations
- Avoids duplicates
- Designed for Zero Trust automation
#>

[CmdletBinding()]
param(
    [string]$ConfigPath = ".\scripts\named-locations\locations-config.json"
)

$ErrorActionPreference = "Stop"

# -----------------------------
# Ensure Graph Connection
# -----------------------------
$requiredScopes = @("Policy.ReadWrite.ConditionalAccess")

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..."
    Connect-MgGraph -Scopes $requiredScopes
}

# -----------------------------
# Load Config
# -----------------------------
if (-not (Test-Path $ConfigPath)) {
    throw "Config file not found: $ConfigPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

# -----------------------------
# Get Existing Locations
# -----------------------------
$existing = Get-MgIdentityConditionalAccessNamedLocation -All

# -----------------------------
# Create IP-Based Locations
# -----------------------------
foreach ($loc in $config.ipLocations) {

    if ($existing.DisplayName -contains $loc.name) {
        Write-Host "Skipping existing IP location: $($loc.name)"
        continue
    }

    Write-Host "Creating IP location: $($loc.name)"

    $body = @{
        "@odata.type" = "#microsoft.graph.ipNamedLocation"
        displayName   = $loc.name
        isTrusted     = $loc.isTrusted
        ipRanges      = @()
    }

    foreach ($ip in $loc.ipRanges) {
        $body.ipRanges += @{
            "@odata.type" = "#microsoft.graph.iPv4CidrRange"
            cidrAddress   = $ip
        }
    }

    New-MgIdentityConditionalAccessNamedLocation -BodyParameter $body
}

# -----------------------------
# Create Geo-Based Locations
# -----------------------------
foreach ($geo in $config.geoLocations) {

    if ($existing.DisplayName -contains $geo.name) {
        Write-Host "Skipping existing geo location: $($geo.name)"
        continue
    }

    Write-Host "Creating Geo location: $($geo.name)"

    $body = @{
        "@odata.type"  = "#microsoft.graph.countryNamedLocation"
        displayName    = $geo.name
        countriesAndRegions = $geo.countries
        includeUnknownCountriesAndRegions = $false
    }

    New-MgIdentityConditionalAccessNamedLocation -BodyParameter $body
}

Write-Host "Named location deployment complete."
