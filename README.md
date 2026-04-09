# 🔐 Microsoft Entra Zero Trust Conditional Access Playbook

![Zero Trust](https://img.shields.io/badge/security-zero--trust-critical)
![Platform](https://img.shields.io/badge/platform-Microsoft%20Entra-purple)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 📌 Overview

This repository provides a **complete, production-ready implementation** of **Zero Trust Conditional Access policies** using Microsoft Entra ID.

It is designed as a **step-by-step playbook** that includes:

* 🔐 Policy design aligned to Zero Trust
* ⚙️ PowerShell-based deployment (Microsoft Graph)
* 🧱 Separation of Entra ID **P1 vs P2 capabilities**
* 📤 Export, backup, and reporting scripts
* 🧪 Testing and validation guidance

---

## 🎯 Objectives

* Enforce **strong authentication everywhere**
* Eliminate **legacy authentication attack paths**
* Protect **privileged identities**
* Require **trusted devices**
* Detect and respond to **identity risk (P2)**

---

## 🧭 Table of Contents

* [Architecture](docs/architecture.md)
* [Zero Trust Principles](docs/zero-trust-principles.md)
* [Licensing (P1 vs P2)](docs/licensing-p1-vs-p2.md)
* [Deployment Guide](docs/deployment-guide.md)
* [Exports & Backup](docs/exports-and-backup.md)

---

## 🧱 Repository Structure

```text
policies/       → Individual Conditional Access policies (self-contained)
scripts/        → Deployment, export, and helper scripts
docs/           → Architecture and guidance
exports/        → Generated JSON + reports
templates/      → Reusable templates
images/         → Diagrams and visuals
```

---

## 🔐 Conditional Access Policy Set

### 🟣 Entra ID P1 — Core Zero Trust Policies

| #  | Policy                   | Purpose                              |
| -- | ------------------------ | ------------------------------------ |
| 01 | Require MFA              | Enforce strong authentication        |
| 02 | Block Legacy Auth        | Remove insecure authentication paths |
| 03 | Require Compliant Device | Ensure trusted endpoints             |
| 04 | Admin Protection         | Secure privileged identities         |
| 05 | Session Controls         | Limit token/session risk             |
| 06 | Location-Based Access    | Context-aware authentication         |

---

### 🔵 Entra ID P2 — Identity Protection Policies

| #  | Policy              | Purpose                         |
| -- | ------------------- | ------------------------------- |
| 07 | User Risk Policy    | Respond to compromised accounts |
| 08 | Sign-in Risk Policy | Block or challenge risky logins |

---

## 🛡️ Zero Trust Coverage

| Threat                  | Protection                  |
| ----------------------- | --------------------------- |
| Password spray          | MFA policy                  |
| Legacy protocol attacks | Block legacy authentication |
| Device compromise       | Device compliance policy    |
| Admin takeover          | Admin protection policy     |
| Token theft             | Session controls            |
| External attacks        | Location-based controls     |
| Account compromise      | User risk policy (P2)       |
| Suspicious logins       | Sign-in risk policy (P2)    |

---

## ⚙️ Deployment

### 1️⃣ Install prerequisites

```powershell
cd scripts/deployment
.\install-prereqs.ps1
```

---

### 2️⃣ Deploy a single policy

```powershell
cd policies/01-require-mfa
.\deploy.ps1
```

---

### 3️⃣ Deploy all policies

```powershell
cd scripts/deployment
.\deploy-policies-bulk.ps1
```

---

### 4️⃣ Create named location

```powershell
cd scripts/named-locations
.\create-named-location.ps1
```

---

## 📤 Export & Backup

Export your current environment:

```powershell
cd scripts/export
.\export-ca-config.ps1
```

Generate:

* Raw JSON (tenant snapshot)
* Import-ready JSON
* Markdown inventory report

---

## 🧪 Testing & Validation

Each policy includes:

* `testing.md`
* Defined test scenarios
* Expected outcomes
* Rollback guidance

Use:

* Microsoft Entra **Sign-in logs**
* Conditional Access evaluation tab
* Identity Protection dashboards (P2)

---

## ⚠️ Deployment Best Practices

* Always start in **Report-only mode**
* Exclude **break-glass accounts**
* Deploy to **pilot groups first**
* Validate with **sign-in logs**
* Communicate changes to users

---

## 🧠 Design Principles

This playbook follows Zero Trust:

* **Verify explicitly** (MFA, risk signals)
* **Use least privilege** (admin protection)
* **Assume breach** (session + risk policies)

---

## 🚀 Recommended Rollout Order

1. Require MFA
2. Block legacy authentication
3. Device compliance
4. Admin protection
5. Session controls
6. Location-based access
7. User risk policy (P2)
8. Sign-in risk policy (P2)

---

## 🔮 Future Enhancements

* Authentication Strength policies
* Phishing-resistant MFA (FIDO2, WHfB)
* Token protection
* Continuous Access Evaluation (CAE)
* Workload identity protection

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

Contributions, improvements, and enhancements are welcome.

---

## ⭐ Summary

This repository provides a **complete Zero Trust Conditional Access framework** that is:

* Modular
* Script-driven
* Scalable
* Enterprise-ready

---
