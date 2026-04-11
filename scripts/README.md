# ⚙️ Scripts — Deployment Guide

This folder contains the PowerShell scripts used to deploy Microsoft Entra Conditional Access policies, create named locations, and back up configuration.

## ✅ Recommended Method

The **bootstrapper** is the primary and recommended way to run this repository.

Use it for:

* first-time setup
* repeat deployments
* named location automation
* full policy deployment
* verification

---

## 📁 Important Scripts

```text
scripts/bootstrap.ps1
scripts/deployment/install-prereqs.ps1
scripts/deployment/deploy-policy.ps1
scripts/deployment/deploy-policies-bulk.ps1
scripts/named-locations/create-named-locations.ps1
scripts/export/export-ca-backup.ps1
```

---

# 🚀 Bootstrapper (Primary Method)

## Step 1 — Open PowerShell

Open PowerShell and change to the repository root.

Example:

```powershell
cd "C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main"
```

You should be in the folder that contains:

```text
docs
images
policies
scripts
README.md
```

---

## Step 2 — Run the bootstrapper with PowerShell 7

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

This will automatically:

1. Unblock downloaded files
2. Install required modules
3. Connect to Microsoft Graph
4. Create or update named locations
5. Deploy all Conditional Access policies
6. Verify the results

---

## Optional bootstrapper modes

### Skip deployment

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1" -SkipDeploy
```

### Skip named locations

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1" -SkipNamedLocations
```

### Skip verification

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1" -SkipVerify
```

---

# 🧪 Verification

After the bootstrapper runs, verify the policies:

```powershell
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State
```

You can also verify in the Microsoft Entra admin center under:

* Protection
* Conditional Access
* Policies

---

# 🛠️ Manual Method (Advanced / Troubleshooting)

Use this only if you want to test individual steps.

## Install prerequisites

```powershell
.\scripts\deployment\install-prereqs.ps1
```

## Deploy one policy

```powershell
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
```

## Deploy all policies

```powershell
.\scripts\deployment\deploy-policies-bulk.ps1
```

## Create or update named locations only

```powershell
.\scripts\named-locations\create-named-locations.ps1
```

---

# ⚠️ PowerShell Version

Use **PowerShell 7** for the bootstrapper and deployment workflow.

Recommended command:

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

Do not use:

```powershell
powershell -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

because that may launch Windows PowerShell instead of PowerShell 7.

---

# ⚠️ Execution Policy

The recommended method uses a temporary execution policy bypass for the current process only:

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

This is the most compatible option for first-time users and does not permanently change the system.

---

# 📤 Backup Script

To back up Conditional Access policies and named locations:

```powershell
.\scripts\export\export-ca-backup.ps1
```

---

# 🔐 Important Notes

* Policies deploy in **report-only mode** by default
* Starter JSON does **not** include break-glass exclusions by default
* Add emergency access exclusions before enabling policies in production
* Replace placeholder network values in `scripts/named-locations/locations-config.json` with your real IP ranges or country settings

---

# 🧠 Summary

## Primary method

```powershell
cd "C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

## Manual method

```powershell
.\scripts\deployment\install-prereqs.ps1
.\scripts\deployment\deploy-policies-bulk.ps1
```
