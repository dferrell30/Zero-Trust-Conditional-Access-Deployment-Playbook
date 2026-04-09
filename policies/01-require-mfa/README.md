# Require MFA for All Users

## Overview

This policy enforces multi-factor authentication for all users across all cloud apps, with emergency access accounts excluded.

## Policy Summary

### Purpose
Require a second factor for sign-in to reduce the risk of password-based compromise.

### Activities Matching Criteria
- All users
- All cloud apps
- Exclude break-glass / emergency accounts

### Actions
- Require multi-factor authentication

### Alerts
- Review Microsoft Entra sign-in logs for MFA failures
- Monitor report-only results before enforcement

### Impact Summary

**For Users:**
- Users will be prompted for MFA
- Users must register supported authentication methods

**For the Organization:**
- Reduces password spray and credential theft risk
- Establishes a Zero Trust baseline for identity

## Use Cases

- Baseline access protection for all users
- Remote and hybrid workforce security
- Compliance-driven strong authentication

## How This Policy Protects Identity

This policy helps protect identity by requiring more than a password during sign-in. Even if a password is stolen, the attacker still needs the second factor to complete authentication.

## Files in this Folder

- `policy.json` — Conditional Access policy definition
- `deploy.ps1` — deploy this specific policy
- `implementation.md` — portal and deployment guidance
- `testing.md` — validation and test steps
