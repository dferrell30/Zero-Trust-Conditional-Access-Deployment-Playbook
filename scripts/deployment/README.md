# ⚙️ PowerShell Setup

## 1. Install PowerShell 7

If needed, install **PowerShell 7**:

**Download:** `https://aka.ms/powershell`

---

## 2. Install Required Modules

Run PowerShell as Administrator:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

---

## 3. Required Permissions

You’ll need these Microsoft Graph scopes:

* `Policy.ReadWrite.ConditionalAccess`
* `Directory.Read.All`
* `Application.Read.All`

---

## 4. Connect to Microsoft Graph

```powershell
Connect-MgGraph -Scopes `
"Policy.ReadWrite.ConditionalAccess",
"Directory.Read.All",
"Application.Read.All"
```

Verify the connection:

```powershell
Get-MgContext
```

---

# 🧱 Reusable Policy Deployment Framework

## Script Location

```text
scripts/deploy-policy.ps1
```

## Example Function

```powershell
function New-ZTConditionalAccessPolicy {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DisplayName,

        [Parameter(Mandatory=$true)]
        [string]$JsonPath
    )

    Write-Host "Creating policy: $DisplayName"

    $json = Get-Content $JsonPath -Raw | ConvertFrom-Json

    New-MgIdentityConditionalAccessPolicy -BodyParameter $json

    Write-Host "Policy created successfully: $DisplayName"
}
```

---

# 🚀 Manual Deployment Steps

## Step 1 — Open PowerShell

Run PowerShell as Administrator.

---

## Step 2 — Connect to Graph

```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"
```

---

## Step 3 — Navigate to the Repository

```powershell
cd C:\GitHub\entra-zero-trust-conditional-access
```

---

## Step 4 — Import the Script

```powershell
. .\scripts\deploy-policy.ps1
```

---

## Step 5 — Deploy Policies

### Deploy a single policy

```powershell
New-ZTConditionalAccessPolicy `
-DisplayName "ZTCA - Require MFA" `
-JsonPath ".\policies\01-require-mfa\policy.json"
```

### Deploy all policies

```powershell
.\deploy-all.ps1
```

---

## Step 6 — Verify

```powershell
Get-MgIdentityConditionalAccessPolicy
```

---

# ⚠️ Critical Notes

## Always

* Exclude break-glass accounts
* Start in **Report-only** mode
* Validate via **Sign-in Logs**

## Replace these placeholders

* `<BREAK_GLASS_OBJECT_ID>`
* `<TRUSTED_LOCATION_ID>`

---

# 🌍 Named Location Script Information

## For an IP named location, users usually change

* `$DisplayName`
* `$IsTrusted`
* `$IpRanges`

## For a country named location, users usually change

* `$DisplayName`
* `$CountriesAndRegions`
* `$IncludeUnknownCountriesAndRegions`

Microsoft documents:

* IP named locations use **IPv4 CIDR** or valid **IPv6** format
* Country named locations use **two-letter country/region codes**

---

# ▶️ How to Run the Named Location Script

Install the Graph module, connect with the required scopes, then run the script.

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "Policy.Read.All","Policy.ReadWrite.ConditionalAccess"
.\create-named-location.ps1
```
