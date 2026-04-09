# Implementation Guide — User Risk Policy

## Goal

Automatically require password change for users identified as high risk by Microsoft Entra ID Identity Protection.

## Prerequisites

- Microsoft Entra ID P2
- Identity Protection enabled
- Azure AD password writeback configured if hybrid remediation is required
- Emergency access accounts identified and excluded
- Self-service password reset configured where appropriate

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection → Conditional Access**
3. Select **New policy**
4. Name:
   - `ZTCA - User Risk Policy`

---

## Assignments

### Users
- Include: All users or a pilot group
- Exclude: Emergency access accounts

### Target Resources
- All cloud apps

---

## Conditions

### User Risk
- Configure = Yes
- Select:
  - High

---

## Access Controls

- Grant access
- Require password change

---

## Enable Policy

- Start with **Report-only**

---

## Scripted Deployment

```powershell
.\deploy.ps1
