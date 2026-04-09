# Implementation Guide — Session Controls Policy

## Goal

Enforce session limits to reduce risk of token theft and long-lived sessions.

## Prerequisites

- Microsoft Entra ID P1 or higher
- Conditional Access policies already in place (MFA baseline)
- Understanding of user impact

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection → Conditional Access**
3. Select **New policy**
4. Name:
   - `ZTCA - Session Controls`

---

## Assignments

### Users
- Include: All users (or pilot group)
- Exclude: Emergency access accounts

---

### Target Resources
- Include: Office 365 (recommended starting point)

---

## Conditions
(Optional)
- Locations → Any
- Device platforms → All

---

## Session Controls

### Sign-in Frequency
- Enable
- Set to: **1 day**

### Persistent Browser Session
- Configure → Disable persistent browser session

---

## Enable Policy

- Start with **Report-only**

---

## Scripted Deployment

```powershell
.\deploy.ps1
