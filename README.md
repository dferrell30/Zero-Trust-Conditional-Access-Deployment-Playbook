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

<img width="2106" height="860" alt="image" src="https://github.com/user-attachments/assets/e2312696-203a-40b9-81b7-1599b5233113" />

<img width="2024" height="860" alt="image" src="https://github.com/user-attachments/assets/ed4e2d31-1b82-4a7e-a6ce-aefd5e591c81" />

<img width="1417" height="740" alt="image" src="https://github.com/user-attachments/assets/a7028012-a37c-442f-998c-04c8783fd9f3" />

<img width="1026" height="560" alt="image" src="https://github.com/user-attachments/assets/e7e64590-6d73-4058-ad75-bd97be4bb505" />

<img width="800" height="496" alt="image" src="https://github.com/user-attachments/assets/01bbba96-08c7-40f7-a276-bd189c2a0155" />

<img width="899" height="495" alt="image" src="https://github.com/user-attachments/assets/98ba82ec-86ba-4a71-a1b0-01b88a820e66" />

<img width="1547" height="993" alt="image" src="https://github.com/user-attachments/assets/72e2ade5-aa42-43ec-8abf-8803726a4bad" />

<img width="914" height="672" alt="image" src="https://github.com/user-attachments/assets/5707d422-802f-487c-ae4a-0e3e19869c08" />

---

## 🔐 Zero Trust Architecture

This implementation uses Microsoft Entra ID as the identity control plane and evaluates access using multiple signals:

- Identity (user, role, risk)
- Device (compliance, join state)
- Location (trusted vs untrusted)
- Session (token lifetime, persistence)

All access decisions are enforced through Conditional Access policies.

---

## 🎯 Attack Path → Policy Mapping

| Attack Technique | Example | Policy That Stops It |
|----------------|--------|---------------------|
| Password Spray | массовые login attempts | Require MFA |
| Legacy Auth Abuse | IMAP/POP brute force | Block Legacy Auth |
| Stolen Credentials | Phishing | MFA + User Risk |
| Token Theft | Session replay | Session Controls |
| Unmanaged Device Access | Personal laptop | Device Compliance |
| Admin Account Takeover | Privilege escalation | Admin Protection |
| Suspicious Login | Impossible travel | Sign-in Risk Policy |
| Compromised Account | Leaked credentials | User Risk Policy |

This ensures **defense in depth across identity, device, and session layers**.

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
