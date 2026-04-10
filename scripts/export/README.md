# 📤 Conditional Access Export & Backup Guide

This folder contains scripts used to **export (back up)** Microsoft Entra Conditional Access policies and named locations to JSON.

This enables:

* Backup of current configuration
* Version control in GitHub
* Change tracking over time
* Disaster recovery / rollback scenarios

---

# 🎯 What This Script Does

The export script will:

* Connect to Microsoft Graph
* Export **all Conditional Access policies**
* Export **all Named Locations**
* Save each object as an individual JSON file
* Create index files for easy reference

---

# 📁 Output Structure

After running the script, files will be created under:

```text
exports/
└── raw/
    ├── conditional-access-policies/
    │   ├── _index.json
    │   ├── ZTCA - Require MFA - All Users__<policy-id>.json
    │   └── ...
    │
    └── named-locations/
        ├── _index.json
        ├── Trusted Location__<location-id>.json
        └── ...
```

---

# 🚀 Step-by-Step Instructions

## 🪜 Step 1 — Open the Repository Root

Open the repository folder in File Explorer.

Click the address bar, type:

```text
powershell
```

Press **Enter**

---

## 🪜 Step 2 — Confirm You Are in the Repo Root

Run:

```powershell
pwd
ls
```

You should see:

```text
docs
images
policies
scripts
exports
README.md
```

---

## 🪜 Step 3 — Allow Script Execution (If Needed)

If PowerShell blocks scripts, run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

## 🪜 Step 4 — Unblock Files (ZIP Downloads Only)

If you downloaded the repo as a ZIP:

```powershell
Get-ChildItem -Recurse | Unblock-File
```

---

## 🪜 Step 5 — Connect to Microsoft Graph

Run:

```powershell
.\scripts\deployment\install-prereqs.ps1
```

This will:

* Install Microsoft Graph module (if needed)
* Prompt for login
* Connect with required permissions

---

## 🪜 Step 6 — Run the Export Script

Run:

```powershell
.\scripts\export\export-ca-backup.ps1
```

---

## 🪜 Optional — Use Timestamped Backup Folder

To create a new folder for each run:

```powershell
.\scripts\export\export-ca-backup.ps1 -UseTimestampFolder
```

Example output:

```text
exports/raw/2026-04-10_134500/
```

---

# 🔍 Verify Export

After running, check:

```powershell
ls .\exports\raw\
```

Then:

```powershell
ls .\exports\raw\conditional-access-policies\
ls .\exports\raw\named-locations\
```

You should see JSON files for each object.

---

# 📄 Understanding the Output

Each policy is exported as:

```text
<PolicyName>__<PolicyId>.json
```

Each folder includes:

```text
_index.json
```

This contains a quick reference list of:

* Policy ID
* Display Name
* State
* File name

---

# ⚠️ Important Notes

## These are BACKUP files

Exported JSON is:

* ✅ Good for backup
* ✅ Good for documentation
* ❌ NOT always directly reusable for deployment

---

## Why not directly reusable?

Exported objects may include:

* Read-only properties
* System-generated fields
* Metadata not accepted by create APIs

---

## Recommended usage

| Use Case            | Supported             |
| ------------------- | --------------------- |
| Backup              | ✅                     |
| Git version control | ✅                     |
| Audit / review      | ✅                     |
| Direct redeploy     | ⚠️ (requires cleanup) |

---

# 🔐 Required Permissions

You must have:

```text
Policy.Read.All
```

This is included when running:

```powershell
install-prereqs.ps1
```

---

# 🧠 Best Practices

## Run exports regularly

* Before major changes
* After deployments
* Before enforcement changes

---

## Store in Git

Commit exports:

```bash
git add exports/
git commit -m "Backup Conditional Access policies"
```

---

## Use timestamped exports

This gives you:

* Historical snapshots
* Rollback capability
* Audit trail

---

# 🚨 Troubleshooting

## Script not found

Make sure you are in repo root:

```powershell
ls
```

---

## Not connected to Graph

Run:

```powershell
.\scripts\deployment\install-prereqs.ps1
```

---

## Access denied

Ensure your account has:

* Conditional Access admin or higher

---

## No policies exported

Verify:

```powershell
Get-MgIdentityConditionalAccessPolicy
```

---

# 🔄 Next Steps

After exporting, you can:

* Build **import-ready JSON**
* Generate **documentation reports**
* Compare policy changes over time
* Implement **policy drift detection**

---

# 🧠 Summary

Basic workflow:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Get-ChildItem -Recurse | Unblock-File
.\scripts\deployment\install-prereqs.ps1
.\scripts\export\export-ca-backup.ps1
```

---

# 🎯 Goal

This export process enables:

👉 Secure backup
👉 Repeatable documentation
👉 Version-controlled Zero Trust architecture
👉 Rapid recovery

---
