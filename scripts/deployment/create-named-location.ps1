<#
.SYNOPSIS
Creates or updates a Microsoft Entra Conditional Access named location.

.DESCRIPTION
- Supports IP named locations and country named locations
- Lets the user tweak a small config block at the top
- Can create or update an existing named location with the same display name
- Uses Microsoft Graph PowerShell SDK

.REQUIREMENTS
- Microsoft.Graph module
- Delegated scopes:
  Policy.Read.All
  Policy.ReadWrite.ConditionalAccess

.NOTES
- For IP named locations, CIDR format is required.
- For country named locations, use 2-letter country codes.
#>

# =========================
# USER CONFIGURATION
# =========================

# Choose: "IP" or "Country"
$LocationType = "IP"

# Friendly display name in Entra ID
$DisplayName = "ZTCA - Trusted HQ Named Location"

# If a named location with this name already exists:
# $true  = update it
# $false = create a new one and error if duplicate handling becomes an issue
$UpdateIfExists = $true

# For IP named locations
$IsTrusted = $true
$IpRanges = @(
    "203.0.113.10/32",
    "198.51.100.0/24"
    # Add more CIDRs here
)

# For Country named locations
$CountriesAndRegions = @(
    "US",
    "CA"
    # Add more 2-letter country codes here
)
$IncludeUnknownCountriesAndRegions = $false

# =========================
# END USER CONFIGURATION
# =========================

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
        Connect-MgGraph -Scopes "Policy.Read.All","Policy.ReadWrite.ConditionalAccess" | Out-Null
    }
    else {
        Write-Host "Already connected to Microsoft Graph as $($ctx.Account)"
    }
}

function Convert-ToIpRangeObjects {
    param(
        [Parameter(Mandatory)]
        [string[]]$Cidrs
    )

    $rangeObjects = @()

    foreach ($cidr in $Cidrs) {
        if ($cidr -match ":") {
            $rangeObjects += @{
                "@odata.type" = "#microsoft.graph.iPv6CidrRange"
                "cidrAddress" = $cidr
            }
        }
        else {
            $rangeObjects += @{
                "@odata.type" = "#microsoft.graph.iPv4CidrRange"
                "cidrAddress" = $cidr
            }
        }
    }

    return $rangeObjects
}

function Get-ExistingNamedLocationByDisplayName {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $all = Get-MgIdentityConditionalAccessNamedLocation -All
    return $all | Where-Object { $_.DisplayName -eq $Name } | Select-Object -First 1
}

function New-OrUpdate-NamedLocation {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("IP","Country")]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$Name,

        [bool]$UpdateExisting = $true,

        [bool]$Trusted = $false,

        [string[]]$Cidrs,

        [string[]]$Countries,

        [bool]$IncludeUnknown = $false
    )

    $existing = Get-ExistingNamedLocationByDisplayName -Name $Name

    if ($Type -eq "IP") {
        if (-not $Cidrs -or $Cidrs.Count -eq 0) {
            throw "You selected IP named location, but no CIDR ranges were provided."
        }

        $body = @{
            "@odata.type" = "#microsoft.graph.ipNamedLocation"
            displayName   = $Name
            isTrusted     = $Trusted
            ipRanges      = @(Convert-ToIpRangeObjects -Cidrs $Cidrs)
        }
    }
    elseif ($Type -eq "Country") {
        if (-not $Countries -or $Countries.Count -eq 0) {
            throw "You selected Country named location, but no country codes were provided."
        }

        $body = @{
            "@odata.type"                       = "#microsoft.graph.countryNamedLocation"
            displayName                         = $Name
            countriesAndRegions                 = @($Countries)
            includeUnknownCountriesAndRegions   = $IncludeUnknown
        }
    }

    if ($existing) {
        if ($UpdateExisting) {
            Write-Host "Updating existing named location: $Name"
            Update-MgIdentityConditionalAccessNamedLocation `
                -NamedLocationId $existing.Id `
                -BodyParameter $body | Out-Null

            $updated = Get-MgIdentityConditionalAccessNamedLocation -NamedLocationId $existing.Id
            return $updated
        }
        else {
            throw "A named location named '$Name' already exists. Set `$UpdateIfExists = `$true to update it."
        }
    }
    else {
        Write-Host "Creating new named location: $Name"
        return New-MgIdentityConditionalAccessNamedLocation -BodyParameter $body
    }
}

# Main
Ensure-GraphModule
Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop
Connect-ToGraphIfNeeded

$result = New-OrUpdate-NamedLocation `
    -Type $LocationType `
    -Name $DisplayName `
    -UpdateExisting:$UpdateIfExists `
    -Trusted:$IsTrusted `
    -Cidrs $IpRanges `
    -Countries $CountriesAndRegions `
    -IncludeUnknown:$IncludeUnknownCountriesAndRegions

Write-Host ""
Write-Host "Completed."
Write-Host "Id:           $($result.Id)"
Write-Host "Display Name: $($result.DisplayName)"
Write-Host "Type:         $($result.AdditionalProperties.'@odata.type')"
