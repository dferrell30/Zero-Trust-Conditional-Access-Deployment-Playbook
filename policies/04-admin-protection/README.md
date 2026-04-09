# Admin Protection Policy

## Overview

This policy enforces stricter Conditional Access controls for privileged accounts to protect high-value identities.

## Policy Summary

### Purpose
Apply enhanced security controls to administrative accounts to reduce the risk of privilege escalation and tenant compromise.

### Activities Matching Criteria
- Users in administrative roles
- All cloud apps

### Actions
- Require MFA
- Require compliant or hybrid joined device

### Alerts
- Monitor admin sign-in logs
- Review risky sign-ins and MFA failures
- Track Conditional Access evaluation results

### Impact Summary

**For Users:**
- Admins must use MFA and managed devices
- Access from unmanaged devices will be blocked

**For the Organization:**
- Protects critical control plane (Entra ID)
- Reduces risk of admin account compromise

## Use Cases

- Securing Global Administrators
- Protecting Privileged Role Administrators
- Enforcing secure admin workstations

## How This Policy Protects Identity

Administrative accounts have elevated permissions and are prime targets. Requiring MFA and trusted devices ensures attackers cannot easily leverage stolen credentials to gain control of the environment.

## Files in this Folder

- `policy.json`
- `deploy.ps1`
- `implementation.md`
- `testing.md`
