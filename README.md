# 🔐 Zero Trust Conditional Access Playbook

## 🎯 Overview

This repository provides a **policy-as-code implementation** of Microsoft Entra Conditional Access aligned to **Zero Trust principles**.

It includes:

* Conditional Access policy JSON definitions
* PowerShell deployment scripts
* Step-by-step deployment guidance
* Testing and validation procedures

---

## 🧱 Architecture

```text
policies/     → Conditional Access policies (JSON + docs)
scripts/      → Deployment and export scripts
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

## 🚀 Deployment

See:

👉 `scripts/README.md`

Key flow:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\deployment\install-prereqs.ps1
.\scripts\deployment\deploy-policy.ps1 -JsonPath ".\policies\01-require-mfa\policy.json"
.\scripts\deployment\deploy-policies-bulk.ps1
```

---

## 🧪 Validation

👉 See full guide:

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

* Verify explicitly (MFA, risk-based)
* Use least privilege (role-based protection)
* Assume breach (risk policies)


---

## 🎯 Goal

Provide a **repeatable, auditable, and scalable** Conditional Access deployment model.


---

## ⚠️ Disclaimer

This data and scripts are provided for **educational, testing, and security validation purposes only**.

Use of this tool should be limited to:
- Authorized environments  
- Lab or approved enterprise systems  

The author assumes **no liability or responsibility** for:
- Misuse of this tool  
- Damage to systems  
- Unauthorized or improper use  

By using this data and scripts, you agree to use it in a lawful and responsible manner.
---

This project is not affiliated with or endorsed by Microsoft.
---


## ⚖️ Professional Disclaimer

This project is an independent work developed in a personal capacity.

The views, opinions, code, and content expressed in this repository are solely my own and do not reflect the views, policies, or positions of any current or future employer, client, or affiliated organization.

No employer, past, present, or future, has reviewed, approved, endorsed, or is in any way associated with these works.

This project was developed outside the scope of any employment and without the use of proprietary, confidential, or restricted resources.

All code/language in this repository is provided under the terms of the included MIT License.
