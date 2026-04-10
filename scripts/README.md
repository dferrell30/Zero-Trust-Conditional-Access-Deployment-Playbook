# ⚙️ Scripts — Deployment & Management Guide

This folder contains all PowerShell scripts used to:

* Deploy Conditional Access policies
* Export tenant configuration
* Generate documentation

---

# 🚀 Quick Start (First-Time Users)

Follow these steps exactly if this is your first time.

---

## 🧱 Step 1 — Get the Repository Locally

You must download or clone this repo before running scripts.

### Option A — Download ZIP (Easiest)

1. Click **Code**
2. Select **Download ZIP**
3. Extract to:

```text
C:\Users\<YourName>\Documents\GitHub\
```

---

### Option B — Clone with Git (Recommended)

```bash
git clone https://github.com/<your-username>/entra-zero-trust-conditional-access.git
```

---

## 🪜 Step 2 — Open PowerShell in the Repo

1. Open the repo folder in File Explorer
2. Click the address bar
3. Type:

```text
powershell
```

4. Press Enter

✅ This opens PowerShell in the correct directory

---

## 🪜 Step 3 — Install Prerequisites

Run:

```powershell
.\scripts\deploy\install-prereqs.ps1
```

This will:

* Install Microsoft Graph PowerShell module
* Connect to Microsoft Graph

---

## 🪜 Step 4 — Load Deployment Functions

```powershell
. .\scripts\deploy\deploy-policy.ps1
```

---

# 🔐 Deploying Policies

## ✅ Option 1 — Deploy One Policy (Recommended First)

```powershell
New-ZTConditionalAccessPolicy `
-DisplayName "ZTCA - Require MFA" `
-JsonPath ".\policies\01-require-mfa\policy.json"
```

---

## ✅ Option 2 — Deploy All Policies

```powershell
.\scripts\deploy\deploy-all.ps1
```

---

# 🧪 Verify Deployment

```powershell
Get-MgIdentityConditionalAccessPolicy
```

---

# 📤 Export & Documentation

## Export raw tenant configuration

```powershell
.\scripts\export\export-raw-ca-config.ps1
```

---

## Build import-ready JSON

```powershell
.\scripts\export\build-import-json.ps1
```

---

## Generate Markdown report

```powershell
.\scripts\export\build-ca-inventory-report.ps1
```

---

# ⚠️ Important Notes

* Always exclude **break-glass accounts**
* Start policies in **Report-only mode**
* Validate using **Sign-in logs** before enabling
* Do NOT run scripts outside the repo directory

---

# 🔧 Troubleshooting

## ❌ “Path not found”

You are not in the repo folder.

Run:

```powershell
ls
```

You should see:

```text
docs
policies
scripts
exports
README.md
```

---

## ❌ Script won’t run

Try:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## ❌ Not connected to Graph

Run:

```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"
```

---

# 🧠 Summary

| Step | Action                  |
| ---- | ----------------------- |
| 1    | Download or clone repo  |
| 2    | Open PowerShell in repo |
| 3    | Install prerequisites   |
| 4    | Deploy policies         |
| 5    | Verify                  |

---

# 🎯 Design Goal

This repo is built to support:

* Repeatable deployments
* Policy-as-code
* Git-based change tracking
* Zero Trust architecture implementation
