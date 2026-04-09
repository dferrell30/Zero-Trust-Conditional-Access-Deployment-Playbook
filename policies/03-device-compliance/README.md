# Require Compliant or Hybrid Joined Device

## Overview

This policy ensures that only trusted devices can access organizational resources by requiring devices to be compliant or hybrid Azure AD joined.

## Policy Summary

### Purpose
Restrict access to corporate resources to managed and trusted devices.

### Activities Matching Criteria
- All users (or selected groups)
- Selected cloud apps (typically Office 365)
- Any device platform

### Actions
- Require device to be marked as compliant OR hybrid Azure AD joined

### Alerts
- Review sign-in logs for device compliance failures
- Monitor Conditional Access report-only results

### Impact Summary

**For Users:**
- Users must enroll devices into Intune or join devices to Entra ID
- Unmanaged devices may be blocked

**For the Organization:**
- Prevents access from unmanaged or potentially compromised devices
- Reduces risk of data exfiltration

## Use Cases

- Protecting Microsoft 365 data (Exchange, SharePoint, Teams)
- Enforcing corporate device standards
- Securing remote and BYOD access scenarios

## How This Policy Protects Identity

By ensuring that only trusted devices can access resources, this policy reduces the risk of compromised endpoints being used to access sensitive data.

## Files in this Folder

- `policy.json`
- `deploy.ps1`
- `implementation.md`
- `testing.md`
