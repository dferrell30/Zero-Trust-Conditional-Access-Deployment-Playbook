# Block Legacy Authentication

## Overview

This policy blocks legacy authentication protocols that do not support modern authentication controls such as MFA.

## Policy Summary

### Purpose
Prevent attackers from using older authentication methods that bypass modern security protections.

### Activities Matching Criteria
- All users
- All cloud apps
- Legacy authentication client apps

### Actions
- Block access

### Alerts
- Review sign-in logs for legacy authentication attempts
- Use report-only results to identify impacted users or apps before enforcement

### Impact Summary

**For Users:**
- Older clients and protocols such as legacy mail apps may stop working
- Users may need to move to modern authentication-supported apps

**For the Organization:**
- Removes a common password spray and brute-force path
- Prevents authentication flows that cannot enforce MFA

## Use Cases

- Blocking IMAP, POP, SMTP AUTH, and other older protocols where applicable
- Eliminating bypass paths for MFA
- Hardening the tenant against password-based attacks

## How This Policy Protects Identity

Legacy authentication is frequently targeted because it cannot enforce many modern security controls. Blocking it removes a major attack surface and helps ensure sign-ins go through modern authentication flows that support Conditional Access.

## Files in this Folder

- `policy.json` — Conditional Access policy definition
- `deploy.ps1` — deploy this specific policy
- `implementation.md` — portal and deployment guidance
- `testing.md` — validation and test steps

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

