# Implementation Guide — Admin Protection Policy

## Goal

Ensure all administrative accounts use strong authentication and secure devices.

## Prerequisites

- Microsoft Entra ID P1 or higher
- Admin roles identified
- Emergency access accounts created
- Intune/device compliance configured
- MFA methods enabled

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection → Conditional Access**
3. Select **New policy**
4. Name:
   - `ZTCA - Admin Protection`

---

## Assignments

### Users
- Include:
  - Directory roles → Select:
    - Global Administrator
    - Privileged Role Administrator
    - Security Administrator
    - Conditional Access Administrator (recommended)
- Exclude:
  - Emergency access accounts

---

### Target Resources
- Include: All cloud apps

---

## Conditions
(Optional)
- Locations → Any
- Device platforms → All

---

## Access Controls

- Grant access
- Require ALL of the following:
  - Require multi-factor authentication
  - Require device to be marked as compliant OR hybrid joined

---

## Enable Policy

- Start with **Report-only**

---

## Scripted Deployment

```powershell
.\deploy.ps1
