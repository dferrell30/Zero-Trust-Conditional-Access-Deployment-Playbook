# Implementation Guide — Location-Based Access Policy

## Goal

Require MFA for users accessing resources from outside trusted locations.

## Prerequisites

- Microsoft Entra ID P1 or higher
- Named location created (trusted network)
- MFA policy already in place

## Step 1 — Create Named Location

Use your script:

```powershell
cd scripts/named-locations
.\create-named-location.ps1****
