# Sign-in Risk Policy

## Overview

This policy evaluates the risk of each sign-in and enforces additional controls such as MFA when suspicious activity is detected.

## Policy Summary

### Purpose
Protect against risky authentication attempts by requiring additional verification or blocking access.

### Activities Matching Criteria
- All users or selected users
- Sign-in risk levels: Medium and High

### Actions
- Require MFA (or block access depending on design)

### Alerts
- Monitor risky sign-ins in Identity Protection
- Review sign-in logs for risk detections
- Track Conditional Access evaluations

### Impact Summary

**For Users:**
- Users may be prompted for MFA during suspicious sign-ins
- Some sign-ins may be blocked if risk is too high

**For the Organization:**
- Prevents unauthorized access from suspicious logins
- Reduces successful account takeover attempts

## Use Cases

- Impossible travel detection
- Anonymous IP usage
- Malware-linked sign-ins
- Suspicious login patterns

## How This Policy Protects Identity

This policy evaluates real-time signals (location, behavior, threat intelligence) and challenges or blocks suspicious sign-ins before access is granted.

## Files in this Folder

- `policy.json`
- `deploy.ps1`
- `implementation.md`
- `testing.md`

## ⚠️ Break-Glass Account Requirement

This policy **does not include break-glass exclusions by default** in the starter configuration.

Before enabling in production:

* Add emergency access account exclusions
* Validate admin access scenarios
* Confirm no lockout risk

Example:

```json
"excludeUsers": [
  "<BREAK_GLASS_OBJECT_ID>"
]
```

Replace with a real object ID before enforcement.
