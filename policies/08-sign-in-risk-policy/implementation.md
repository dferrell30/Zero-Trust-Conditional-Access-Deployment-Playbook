# Implementation Guide — Sign-in Risk Policy

## Goal

Require MFA or block access when sign-in risk is detected.

## Prerequisites

- Microsoft Entra ID P2
- Identity Protection enabled
- MFA policy already deployed
- Emergency access accounts identified

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection → Conditional Access**
3. Select **New policy**
4. Name:
   - `ZTCA - Sign-in Risk Policy`

---

## Assignments

### Users
- Include: All users or pilot group
- Exclude: Emergency access accounts

---

### Target Resources
- All cloud apps

---

## Conditions

### Sign-in Risk
- Configure = Yes
- Select:
  - Medium
  - High

---

## Access Controls

### Recommended (Balanced Approach)
- Grant access
- Require MFA

### Optional (Stronger Control)
- Block access for High risk

---

## Enable Policy

- Start with **Report-only**

---

## Scripted Deployment

```powershell
.\deploy.ps1
