<#
.SYNOPSIS
Create or update a Conditional Access named location (IP or Country).

.DESCRIPTION
- Supports IP ranges (CIDR)
- Supports country-based locations
- Updates if name already exists
#>

# =========================
# USER CONFIGURATION
# =========================

# Type: "IP" or "Country"
$LocationType = "IP"

# Name shown in Entra
$DisplayName = "ZTCA - Trusted Location"

# Update existing if found
$UpdateIfExists = $true

# IP-based config
$IsTrusted = $true
$IpRanges = @(
    "203.0.113.10/32",
    "198.51.100.0/24"
)

# Country-based config
$CountriesAndRegions = @(
    "US",
    "CA"
)
$IncludeUnknownCountriesAndRegions = $false

# =========================

$ErrorActionPreference = "Stop"

function Connect-Graph {
    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    if (-not $ctx) {
        Connect-MgGraph -Scopes "Policy.Read.All","Policy.ReadWrite.ConditionalAccess"
    }
}

function Get-NamedLocation {
    param($Name)
    Get-MgIdentityConditionalAccessNamedLocation -All |
        Where-Object { $_.DisplayName -eq $Name } |
        Select-Object -First 1
}

function Convert-IpRanges {
    param($Ranges)

    $output = @()

    foreach ($r in $Ranges) {
        if ($r -match ":") {
            $output += @{
                "@odata.type" = "#microsoft.graph.iPv6CidrRange"
                cidrAddress   = $r
            }
        }
        else {
            $output += @{
                "@odata.type" = "#microsoft.graph.iPv4CidrRange"
                cidrAddress   = $r
            }
        }
    }

    return $output
}

Connect-Graph

$existing = Get-NamedLocation -Name $DisplayName

if ($LocationType -eq "IP") {
    $body = @{
        "@odata.type" = "#microsoft.graph.ipNamedLocation"
        displayName   = $DisplayName
        isTrusted     = $IsTrusted
        ipRanges      = @(Convert-IpRanges -Ranges $IpRanges)
    }
}
else {
    $body = @{
        "@odata.type"                     = "#microsoft.graph.countryNamedLocation"
        displayName                       = $DisplayName
        countriesAndRegions               = $CountriesAndRegions
        includeUnknownCountriesAndRegions = $IncludeUnknownCountriesAndRegions
    }
}

if ($existing -and $UpdateIfExists) {
    Write-Host "Updating existing named location..."
    Update-MgIdentityConditionalAccessNamedLocation `
        -NamedLocationId $existing.Id `
        -BodyParameter $body
}
elseif (-not $existing) {
    Write-Host "Creating new named location..."
    New-MgIdentityConditionalAccessNamedLocation -BodyParameter $body
}
else {
    Write-Host "Named location exists and update disabled."
}
