# 🔐 Microsoft Entra Zero Trust Conditional Access Playbook

![Zero Trust](https://img.shields.io/badge/security-zero--trust-critical)
![Entra](https://img.shields.io/badge/platform-Entra%20ID-purple)

---

## 📌 Overview

This repository provides a **complete, production-ready implementation guide** for designing and deploying **Zero Trust Conditional Access policies** in Microsoft Entra ID.

---

## 🎯 Objectives

* Enforce **strong authentication everywhere**
* Eliminate **legacy attack paths**
* Protect **privileged identities**
* Require **trusted devices**
* Detect and respond to **identity risk (P2)**

---

## 🧭 Navigation

* 📘 [Architecture](docs/architecture.md)
* 🧠 [Zero Trust Principles](docs/zero-trust-principles.md)
* 🧾 [Licensing (P1 vs P2)](docs/licensing-p1-vs-p2.md)

---

## 🔐 Core Policies

| #  | Policy                   | License |
| -- | ------------------------ | ------- |
| 01 | Require MFA              | P1      |
| 02 | Block Legacy Auth        | P1      |
| 03 | Require Compliant Device | P1      |
| 04 | Admin Protection         | P1      |
| 05 | Session Controls         | P1      |
| 06 | Location-Based Access    | P1      |
| 07 | User Risk Policy         | P2      |
| 08 | Sign-in Risk Policy      | P2      |

---

## 🚀 Deployment Strategy

1. Deploy in **Report-only mode**
2. Validate via **Sign-in Logs**
3. Pilot with **IT users**
4. Gradually enforce
5. Monitor continuously

---

## 🛡️ Zero Trust Coverage

| Threat           | Control            |
| ---------------- | ------------------ |
| Password spray   | MFA                |
| Token theft      | Session controls   |
| Legacy bypass    | Block legacy auth  |
| Admin compromise | Admin CA policies  |
| Account takeover | Risk policies (P2) |

---

## 🔮 Roadmap

* Authentication Strengths
* Token Protection
* Continuous Access Evaluation (CAE)

---

# ✅ Conditional Access Rollout Checklist

- [ ] Break-glass accounts excluded
- [ ] Policies in Report-only
- [ ] Sign-in logs reviewed
- [ ] Pilot group tested
- [ ] MFA registration complete
- [ ] Legacy auth identified
- [ ] Policies enabled
