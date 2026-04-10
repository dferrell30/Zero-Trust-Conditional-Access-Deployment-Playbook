# 🚀 Script Deployment Guide

This folder contains the PowerShell scripts used to deploy Microsoft Entra Conditional Access policies from the JSON files in this repository.

These instructions are written for a first-time user and assume the repository was downloaded from GitHub as a ZIP file.

---

## Folder Layout Used by These Steps

These instructions assume the repository uses this script path:

```text
scripts/deployment/
```

with these files:

```text
scripts/deployment/install-prereqs.ps1
scripts/deployment/deploy-policy.ps1
scripts/deployment/deploy-policies-bulk.ps1
```

---

## Before You Start

You need:

* A local copy of this repository on your computer
* PowerShell
* Internet access to install the Microsoft Graph PowerShell module
* Permissions to create Conditional Access policies in Microsoft Entra

---

## Step 1 — Download or Clone the Repository

### Option A — Download ZIP

1. Open the repository in GitHub
2. Click **Code**
3. Click **Download ZIP**
4. Extract the ZIP to a local folder

Example:

```text
C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main
```

### Option B — Clone with Git

```bash
git clone https://github.com/<your-username>/Zero-Trust-Conditional-Access-Playbook.git
```
--- 

## ⚠️ PowerShell Execution Policy

## PowerShell execution options

### Recommended for most users

Use a temporary execution-policy bypass for the current PowerShell session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Get-ChildItem -Recurse | Unblock-File
```

This is the most compatible option for first-time users because it does not permanently change the system.

### Optional for repeat local use

If you run the scripts often on your own workstation, you can set:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
Get-ChildItem -Recurse | Unblock-File
```

This reduces the need to run the temporary bypass each time.

### Enterprise option

For managed environments, consider code-signing the scripts or deploying through CI/CD instead of relying on local execution.

Run each line individually.

```Powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
```Powershell
Get-ChildItem -Recurse | Unblock-File
```
---

## Step 2 — Open the Repository Root

The **repository root** is the main folder that contains:

```text
docs
images
policies
scripts
templates
README.md
LICENSE
```

### Easiest way to open PowerShell in the repo root

1. Open the repository folder in File Explorer
2. Click the address bar at the top
3. Type:

```text
powershell
```

4. Press **Enter**

A PowerShell window will open in the correct folder.

---

## Step 3 — Confirm You Are in the Repo Root

Run:

```powershell
pwd
ls
```

You should see the repository path and a file/folder list that includes:

```text
docs
images
policies
scripts
templates
README.md
```

If you see only the contents of the `scripts` folder, go up one level:

```powershell
cd ..
```

Then run `ls` again.

---

## Step 4 — If PowerShell Blocks Scripts, Use a One-Time Bypass

If you see errors about scripts not being digitally signed or blocked by execution policy, run this in the same PowerShell window:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

This bypass only applies to the current PowerShell window.

If the repository was downloaded as a ZIP file, Windows may mark the files as blocked. Run this from the repo root:

```powershell
Get-ChildItem -Recurse | Unblock-File
```

These two commands are safe and are often needed when running local `.ps1` files for the first time.

---

## Step 5 — Install Prerequisites and Connect to Microsoft Graph

Run:

```powershell
.\scripts\deployment\install-prereqs.ps1
```

This script should:

* Install the Microsoft Graph PowerShell module if needed
* Import the required Graph module
* Prompt you to sign in
* Connect to Microsoft Graph with the required scopes

### Expected result

You should see output showing that you connected to Microsoft Graph successfully.

---

## Step 6 — Deploy One Policy First

Always test with one policy before bulk deployment.

Run:

```powershell
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
```

### What this does

* Reads the JSON file for the policy
* Uses Microsoft Graph to create the Conditional Access policy
* Returns the new policy details if successful

### Important

Run this in the **same PowerShell window** used for `install-prereqs.ps1`.

Do not open a new PowerShell window between Step 5 and Step 6 unless you reconnect to Microsoft Graph again.

---

## Step 7 — Verify the Policy

Run:

```powershell
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State
```

You should see the new policy in the results.

You can also verify it in the Microsoft Entra admin center under:

* **Protection**
* **Conditional Access**
* **Policies**

---

## Step 8 — Deploy All Policies After Testing

Once a single policy works, deploy the rest:

```powershell
.\scripts\deployment\deploy-policies-bulk.ps1
```

This script should find every `policy.json` file under the `policies` folder and deploy them one at a time.

---

## Exact Command Sequence

Run these commands one at a time from the **repo root**:

```powershell
pwd
ls
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Get-ChildItem -Recurse | Unblock-File
.\scripts\deployment\install-prereqs.ps1
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State
```

After that, if the test policy works:

```powershell
.\scripts\deployment\deploy-policies-bulk.ps1
```

---

## Common Mistakes and Fixes

### Problem: Script file is not recognized

Example:

```text
The term '.\scripts\deployment\install-prereqs.ps1' is not recognized...
```

### Cause

You are not in the repo root.

### Fix

Run:

```powershell
pwd
ls
```

Make sure you see:

```text
docs
images
policies
scripts
README.md
```

If you are inside the `scripts` folder, go back to the root:

```powershell
cd ..
```

---

### Problem: Script is not digitally signed

Example:

```text
cannot be loaded because it is not digitally signed
```

### Fix

Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Get-ChildItem -Recurse | Unblock-File
```

Then rerun the script.

---

### Problem: Not connected to Microsoft Graph

Example:

```text
Not connected to Microsoft Graph
```

### Cause

You opened a new PowerShell window or started a separate PowerShell process after connecting.

### Fix

Run these in the same PowerShell window:

```powershell
.\scripts\deployment\install-prereqs.ps1
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
```

---

### Problem: Invalid user value `<BREAK_GLASS_OBJECT_ID>`

### Cause

The JSON file contains a placeholder value that is not a real Entra object ID.

### Fix

For starter deployment, remove the `excludeUsers` section from the policy JSON until you are ready to add real emergency access account IDs.

---

## Recommended Deployment Approach

Use this order:

1. Open PowerShell in the repo root
2. Apply the one-time execution bypass if needed
3. Run `install-prereqs.ps1`
4. Deploy one simple policy first
5. Verify it in Entra and in PowerShell
6. Deploy the rest only after the first test succeeds

---

## Current Starter Approach for This Repo

To make initial deployment easier, the starter policy JSON files should not include break-glass exclusions until you are ready to replace placeholders with real account object IDs.

This makes the policies easier to test, but you must be careful before enabling production enforcement.

---

## Production Warning

Before turning any policy fully on in production:

* Add emergency access account exclusions
* Validate assignments carefully
* Start in **Report-only**
* Review sign-in logs
* Confirm no administrative lockout risk

---

## Summary

The basic workflow is:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Get-ChildItem -Recurse | Unblock-File
.\scripts\deployment\install-prereqs.ps1
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
.\scripts\deployment\deploy-policies-bulk.ps1
```

Run those commands from the **repository root**, one at a time.
