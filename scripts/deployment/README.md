# ⚙️ PowerShell Setup & Deployment

## 🚀 Recommended Method (Bootstrapper)

The **bootstrapper is the primary and easiest way** to run this project.

It will:

* install required modules
* connect to Microsoft Graph
* create/update named locations
* deploy all Conditional Access policies
* verify results

---

## 🪜 Step 1 — Open PowerShell 7

Install PowerShell 7 if needed:

`https://aka.ms/powershell`

---

## 🪜 Step 2 — Navigate to the Repository

```powershell
cd "C:\Path\To\Zero-Trust-Conditional-Access-Playbook"
```

---

## 🪜 Step 3 — Run the Bootstrapper

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

---

## 🧪 Verify Deployment

```powershell
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State
```

---

# ⚠️ Important Notes

* All policies deploy in **Report-only mode**
* No access is blocked during initial deployment
* Validate policies before enabling enforcement

---

# 🔐 Required Permissions

The bootstrapper will prompt for Microsoft Graph scopes:

* `Policy.ReadWrite.ConditionalAccess`
* `Directory.Read.All`
* `Application.Read.All`

---

# 🧱 Manual Method (Advanced / Troubleshooting)

Use this only if needed.

---

## 📦 Install Required Modules

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

---

## 🔑 Connect to Microsoft Graph

```powershell
Connect-MgGraph -Scopes `
"Policy.ReadWrite.ConditionalAccess",
"Directory.Read.All",
"Application.Read.All"
```

---

## 📂 Navigate to Repo

```powershell
cd C:\GitHub\entra-zero-trust-conditional-access
```

---

## 📜 Import Script

```powershell
. .\scripts\deploy-policy.ps1
```

---

## 🚀 Deploy Policies

### Single policy

```powershell
New-ZTConditionalAccessPolicy `
-DisplayName "ZTCA - Require MFA" `
-JsonPath ".\policies\01-require-mfa\policy.json"
```

### All policies

```powershell
.\deploy-all.ps1
```

---

## 🔍 Verify

```powershell
Get-MgIdentityConditionalAccessPolicy
```

---

# 🌍 Named Location Script Information

## For IP named locations, change:

* `$DisplayName`
* `$IsTrusted`
* `$IpRanges`

## For country named locations, change:

* `$DisplayName`
* `$CountriesAndRegions`
* `$IncludeUnknownCountriesAndRegions`

---

## ▶️ Run Named Location Script Manually

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "Policy.Read.All","Policy.ReadWrite.ConditionalAccess"
.\create-named-location.ps1
```

---

# ⚠️ Critical Production Notes

Always:

* Exclude break-glass accounts
* Validate in **Report-only mode**
* Test via **Sign-in Logs**

Replace placeholders:

* `<BREAK_GLASS_OBJECT_ID>`
* `<TRUSTED_LOCATION_ID>`
