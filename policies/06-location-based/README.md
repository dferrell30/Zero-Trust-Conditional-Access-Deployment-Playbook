# Location-Based Access Policy

## Overview

This policy enforces stronger authentication requirements when users access resources from outside trusted locations.

## Policy Summary

### Purpose
Ensure that access from untrusted networks requires additional verification.

### Activities Matching Criteria
- All users
- Office 365 applications
- Any location except trusted locations

### Actions
- Require MFA when outside trusted locations

### Alerts
- Monitor sign-ins from unknown or external locations
- Review Conditional Access results for location-based triggers

### Impact Summary

**For Users:**
- MFA required when outside corporate network
- Seamless experience on trusted networks

**For the Organization:**
- Reduces risk from external access
- Adds contextual security based on location

## Use Cases

- Remote workforce security
- Corporate network trust boundary
- Conditional access based on network context

## How This Policy Protects Identity

Attackers typically operate outside trusted networks. By requiring MFA outside those locations, this policy adds an additional layer of protection against unauthorized access.

## Files in this Folder

- `policy.json`
- `deploy.ps1`
- `implementation.md`
- `testing.md`
