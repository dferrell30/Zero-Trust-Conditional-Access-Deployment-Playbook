# 🔐 Zero Trust Conditional Access Playbook

![Microsoft Entra ID](https://img.shields.io/badge/Platform-Microsoft%20Entra%20ID-5E5ADB?style=for-the-badge)
![Zero Trust](https://img.shields.io/badge/Security-Zero%20Trust-0A66C2?style=for-the-badge)
![Conditional Access](https://img.shields.io/badge/Focus-Conditional%20Access-0078D4?style=for-the-badge)
![PowerShell](https://img.shields.io/badge/Automation-PowerShell-5391FE?style=for-the-badge)
![License MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> A practical, deployable Zero Trust Conditional Access baseline.

## ⚡ Quick Start

Run the bootstrapper to install prerequisites, connect to Microsoft Graph, create named locations, deploy policies, and verify results.

```powershell
cd "C:\Path\To\Zero-Trust-Conditional-Access-Playbook"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

---

## 🎯 Overview

This repository provides a **policy-as-code implementation** of Microsoft Entra Conditional Access aligned to **Zero Trust principles**.

It is designed to help organizations move from **basic MFA enforcement** to a **layered Zero Trust access model**.

Included in this repository:

* Conditional Access policy JSON definitions
* PowerShell deployment scripts
* Automated named location creation
* Testing and validation procedures
* A one-command bootstrap deployment method

---

## 📚 Table of Contents

- [Quick Start](#-quick-start)
- [Overview](#-overview)
- [Core Policies](#-core-policies-entra-p1)
- [Identity Protection](#-identity-protection-entra-p2)
- [Execution](#-execution)
- [Validation](#-validation)

---

## 👥 Who This Is For

* Microsoft Entra administrators
* Identity and access engineers
* Security architects
* Microsoft 365 / Zero Trust practitioners
* Teams building a production-ready Conditional Access baseline

---

## 🧱 Architecture

policies/ → Conditional Access policies (JSON + docs)
scripts/ → Deployment, bootstrap, and automation
docs/ → Validation and implementation guides
images/ → Screenshots and diagrams

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

## 🧠 Identity Protection — Operational Readiness

Risk-based policies are **not just configuration**. They require investigation and response.

### 🔍 Where to Investigate

* Identity Protection → Risky users
* Identity Protection → Risk detections
* Monitoring → Sign-in logs

---

## 🛠️ Responding to Risk

### User Risk

* Require password reset
* Require MFA
* Confirm or dismiss risk

### Sign-in Risk

* Require MFA challenge
* Block high-risk attempts
* Investigate:

  * location anomalies
  * device context
  * sign-in patterns

---

## ⚠️ Before Enabling Risk Policies

* Validate policies in report-only mode
* Ensure remediation workflows are understood
* Test with non-production users
* Confirm P2 licensing is available

---

## ⚙️ Execution

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

---

## 🧪 Validation

See:

docs/validation-playbook.md

Validation includes:

* Sign-in log analysis
* Risk simulation
* Report-only evaluation
* Enforcement readiness

---

## ⚠️ Safety Requirements

* Add break-glass account exclusions
* Test admin/service accounts
* Validate report-only results
* Confirm no lockout scenarios

---

## 🔐 Zero Trust Alignment

* Verify explicitly
* Use least privilege
* Assume breach

---

## 🧪 Real-World Scenario

Credential theft from unmanaged device:

Without Conditional Access:

* attacker gains access
* session persists
* lateral movement begins

With this playbook:

* MFA enforced
* device blocked
* risk triggers session revoke
* session controls limit persistence

---

## 📌 Status

* MVP Complete
* Bootstrap Automation Working
* Validation Ready
* Requires production hardening

---

## 🎯 Goal

Provide a **repeatable, auditable, and scalable** Conditional Access deployment model.

---

## 🔁 Safe to Re-Run

```powershell
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

---

## ⚠️ Disclaimer

Use only in authorized environments. No liability for misuse.

Not affiliated with Microsoft.

---

## ⚖️ Professional Disclaimer

This is an independent project built in a personal capacity with no employer affiliation.
