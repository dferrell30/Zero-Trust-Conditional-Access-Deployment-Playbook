# Implementation Guide — Require MFA for All Users

## Goal

Deploy a Conditional Access policy that requires MFA for all users and all cloud apps, while excluding emergency access accounts.

## Prerequisites

- Microsoft Entra ID P1 or higher
- At least two emergency access accounts created and excluded
- Users prepared for MFA registration
- Microsoft Graph PowerShell installed for scripted deployment

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection** → **Conditional Access**
3. Select **New policy**
4. Name the policy:
   - `ZTCA - Require MFA - All Users`
5. Under **Assignments**:
   - **Users**: Include **All users**
   - Exclude emergency access / break-glass accounts
6. Under **Target resources**:
   - Include **All cloud apps**
7. Under **Access controls** → **Grant**:
   - Select **Grant access**
   - Check **Require multi-factor authentication**
8. Under **Enable policy**:
   - Start with **Report-only**
9. Create the policy

## Scripted Deployment

From this folder:

```powershell
.\deploy.ps1
