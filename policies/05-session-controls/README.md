# Session Controls Policy

## Overview

This policy enforces session controls such as sign-in frequency and browser persistence to reduce the risk of token theft and unauthorized persistent access.

## Policy Summary

### Purpose
Limit session duration and enforce periodic reauthentication to reduce risk from stolen tokens or long-lived sessions.

### Activities Matching Criteria
- All users (or selected groups)
- Selected cloud apps (typically Office 365)

### Actions
- Enforce sign-in frequency
- Control persistent browser sessions

### Alerts
- Monitor sign-in logs for reauthentication behavior
- Review Conditional Access session control results

### Impact Summary

**For Users:**
- Users will be prompted to reauthenticate periodically
- Browser sessions may not remain signed in

**For the Organization:**
- Reduces risk of session hijacking
- Limits attacker dwell time

## Use Cases

- Protecting high-value SaaS apps (M365)
- Reducing exposure from shared devices
- Enforcing tighter session boundaries

## How This Policy Protects Identity

Even if authentication is successful, attackers may attempt to reuse tokens. This policy forces reauthentication and limits how long sessions remain valid, reducing exposure.

## Files in this Folder

- `policy.json`
- `deploy.ps1`
- `implementation.md`
- `testing.md`
