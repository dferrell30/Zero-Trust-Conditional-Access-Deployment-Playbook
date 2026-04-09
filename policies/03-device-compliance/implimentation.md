# Implementation Guide — Require Compliant Device

## Goal

Ensure that only devices that meet security requirements can access organizational resources.

## Prerequisites

- Microsoft Entra ID P1 or higher
- Microsoft Intune configured
- Compliance policies created in Intune
- Devices enrolled or hybrid joined
- Emergency accounts identified

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection → Conditional Access**
3. Select **New policy**
4. Name:
   - `ZTCA - Require Compliant Device`

### Assignments

- **Users**:
  - Include: All users (or pilot group)
  - Exclude: Emergency accounts

- **Target resources**:
  - Select: Office 365 (recommended starting point)

### Conditions

(Optional but recommended)
- Device platforms → All
- Locations → Any

### Access Controls

- Grant → Grant access
- Require one of the following:
  - Require device to be marked as compliant
  - Require hybrid Azure AD joined device

### Enable Policy

- Start with **Report-only**

## Scripted Deployment

```powershell
.\deploy.ps1
