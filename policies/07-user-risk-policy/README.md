# User Risk Policy

## Overview

This policy responds to identities that Microsoft Entra ID has determined are likely compromised by requiring secure remediation.

## Policy Summary

### Purpose
Protect the organization from compromised user accounts by requiring password change when user risk is detected.

### Activities Matching Criteria
- All users or selected users
- User risk level = High

### Actions
- Require password change

### Alerts
- Review Identity Protection detections
- Monitor risky users and remediation events
- Track Conditional Access evaluation results

### Impact Summary

**For Users:**
- Users flagged as high risk must reset their password
- Legitimate users may need to complete remediation after suspicious activity

**For the Organization:**
- Helps contain compromised accounts
- Reduces attacker persistence after credential theft

## Use Cases

- Responding to leaked credentials
- Responding to high-confidence account compromise
- Automating identity remediation for risky users

## How This Policy Protects Identity

When Microsoft Entra identifies a user as high risk, this policy forces remediation through password change. This helps remove attacker access and restores trust in the account.

## Files in this Folder

- `policy.json`
- `deploy.ps1`
- `implementation.md`
- `testing.md`
