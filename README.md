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

## 🔐 Zero Trust Architecture

<img width="964" height="630" alt="image" src="https://github.com/user-attachments/assets/f2056820-6151-4cce-a29a-a5d70fba7e67" />

This implementation uses Microsoft Entra ID as the identity control plane and evaluates access using multiple signals:

- Identity (user, role, risk)
- Device (compliance, join state)
- Location (trusted vs untrusted)
- Session (token lifetime, persistence)

All access decisions are enforced through Conditional Access policies.

---

## 🔄 Deployment Flow

<img width="1085" height="354" alt="image" src="https://github.com/user-attachments/assets/add1e86d-7106-499d-a2a5-9c1551386add" />

This flow represents how Conditional Access evaluates every sign-in attempt:

1. User initiates authentication
2. Microsoft Entra evaluates signals:
   - Identity risk
   - Device compliance
   - Location
   - Session context
3. Conditional Access policies are applied
4. Access is:
   - Granted
   - Challenged (MFA)
   - Blocked

This ensures every access request is continuously validated under Zero Trust principles.

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

## 🔐 Phishing-Resistant MFA (Recommended Enhancement)

To further strengthen identity security, implement phishing-resistant authentication methods:

### Supported Methods

- FIDO2 Security Keys
- Windows Hello for Business (WHfB)
- Certificate-Based Authentication (CBA)

### Benefits

- Resistant to phishing attacks
- Eliminates OTP fatigue attacks
- Strong device-bound authentication

### Integration with This Repo

These methods can be enforced using:

- Authentication Strength policies
- Conditional Access grant controls

### Future Enhancement

This repository can be extended to include:

- Authentication Strength enforcement
- Phishing-resistant MFA rollout guide

<img width="1199" height="786" alt="image" src="https://github.com/user-attachments/assets/856fc566-5ac7-4aca-8b1c-211b575680ed" />

Traditional MFA can still be vulnerable to phishing and fatigue attacks.

Phishing-resistant authentication methods provide stronger protection:

- FIDO2 security keys
- Windows Hello for Business
- Certificate-based authentication

These methods are resistant to replay, interception, and phishing attacks.

This repository can be extended to enforce authentication strength policies for phishing-resistant MFA.

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

## 🧠 Zero Trust Maturity Model

<img width="1351" height="860" alt="image" src="https://github.com/user-attachments/assets/8d4f5ac8-e5c6-4bad-b2d8-46d2de39ebd9" />

This implementation aligns to a Zero Trust maturity model:

### Level 1 — Basic Protection
- MFA enforcement
- Block legacy authentication

### Level 2 — Device Trust
- Require compliant or hybrid joined devices
- Admin protection policies

### Level 3 — Session & Context
- Session controls
- Location-based access

### Level 4 — Identity Protection (P2)
- User risk policy
- Sign-in risk policy

This repository delivers a full progression from baseline security to advanced Zero Trust enforcement.

---

## ⚠️ Disclaimer

This tool is provided for **educational, testing, and security validation purposes only**.

Use of this tool should be limited to:
- Authorized environments  
- Lab or approved enterprise systems  

The author assumes **no liability or responsibility** for:
- Misuse of this tool  
- Damage to systems  
- Unauthorized or improper use  

By using this tool, you agree to use it in a lawful and responsible manner.
---

This project is not affiliated with or endorsed by Microsoft.
---


## ⚖️ Professional Disclaimer

This project is an independent work developed in a personal capacity.

The views, opinions, code, and content expressed in this repository are solely my own and do not reflect the views, policies, or positions of any current or future employer, client, or affiliated organization.

No employer, past, present, or future, has reviewed, approved, endorsed, or is in any way associated with these works.

This project was developed outside the scope of any employment and without the use of proprietary, confidential, or restricted resources.

All code/language in this repository is provided under the terms of the included MIT License.
