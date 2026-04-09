# Implementation Guide — Block Legacy Authentication

## Goal

Deploy a Conditional Access policy that blocks legacy authentication across the tenant.

## Prerequisites

- Microsoft Entra ID P1 or higher
- Inventory of apps, devices, or workflows that may still rely on legacy authentication
- Emergency access accounts considered in your Conditional Access design
- Microsoft Graph PowerShell installed for scripted deployment

## Portal Configuration

1. Go to **Microsoft Entra admin center**
2. Navigate to **Protection** → **Conditional Access**
3. Select **New policy**
4. Name the policy:
   - `ZTCA - Block Legacy Authentication`
5. Under **Assignments**:
   - **Users**: Include **All users**
   - Exclude emergency access / break-glass accounts if required by your operating model
6. Under **Target resources**:
   - Include **All cloud apps**
7. Under **Conditions**:
   - **Client apps** → Configure = **Yes**
   - Select **Exchange ActiveSync clients**
   - Select **Other clients**
8. Under **Access controls** → **Grant**:
   - Select **Block access**
9. Under **Enable policy**:
   - Start with **Report-only**
10. Create the policy

## Scripted Deployment

From this folder:

```powershell
.\deploy.ps1
