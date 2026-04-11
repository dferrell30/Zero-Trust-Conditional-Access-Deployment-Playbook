# 🔐 Zero Trust Conditional Access Playbook

## 🚀 Quick Start (Recommended)

```powershell
cd "C:\Path\To\Zero-Trust-Conditional-Access-Playbook"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

This runs the full deployment automatically:

* installs prerequisites
* connects to Microsoft Graph
* creates named locations
* deploys all policies
* verifies results

## 🎯 Overview

This repository provides a **policy-as-code implementation** of Microsoft Entra Conditional Access aligned to **Zero Trust principles**.

It includes:

* Conditional Access policy JSON definitions
* PowerShell deployment scripts
* Automated named location creation
* Testing and validation procedures
* A one-command bootstrap deployment method

---

## 🚀 Start Here

The **recommended way** to run this repository is with the **bootstrapper**.

The bootstrapper:

* unblocks downloaded files
* installs prerequisites
* connects to Microsoft Graph
* creates or updates named locations
* deploys all Conditional Access policies
* verifies deployed policies

---

## 🪜 Quick Start

### Step 1 — Open PowerShell

Open PowerShell and change to the local repository folder.

Example:

```powershell
cd "C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main"
```

### Step 2 — Run the bootstrapper with PowerShell 7

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

---

## 🧱 Architecture

```text
policies/     → Conditional Access policies (JSON + docs)
scripts/      → Deployment, bootstrap, and export scripts
docs/         → Validation and implementation guides
images/       → Screenshots and diagrams
```

---

## 🔐 Core Policies (Entra P1)

| Policy            | Purpose                      |
| ----------------- | ---------------------------- |
| Require MFA       | Enforce MFA across all users |
| Block Legacy Auth | Block basic authentication   |
| Device Compliance | Require compliant devices    |
| Admin Protection  | Stronger controls for admins |
| Session Controls  | Manage session lifetime      |
| Location Policy   | Restrict risky locations     |

---

## 🧠 Identity Protection (Entra P2)

| Policy              | Purpose                         |
| ------------------- | ------------------------------- |
| User Risk Policy    | Respond to compromised accounts |
| Sign-in Risk Policy | Respond to risky sign-ins       |

---

## ⚙️ Recommended Execution Method

Use the bootstrapper as the **primary execution method**:

```powershell
cd "C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

For detailed script usage, see:

```text
scripts/README.md
```

---

## 🧪 Validation

Use the validation guide after deployment:

```text
docs/validation-playbook.md
```

Validation includes:

* Sign-in log analysis
* Risk simulation
* Report-only verification
* Enforcement readiness checks

---

## ⚠️ Safety Requirements

Before enabling policies:

* Add break-glass account exclusions
* Validate all policies in report-only mode
* Test admin and service accounts
* Confirm no lockout scenarios

---

## 🔐 Zero Trust Alignment

This repo enforces:

* Verify explicitly
* Use least privilege
* Assume breach

---

## 📌 Status

* ✅ MVP Complete
* ✅ Bootstrap Automation Working
* ✅ Validation Ready
* ⚠️ Requires production hardening before enforcement

---

## 🎯 Goal

Provide a **repeatable, auditable, and scalable** Conditional Access deployment model.
