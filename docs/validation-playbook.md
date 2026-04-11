# 🧪 Zero Trust Conditional Access — Validation Playbook

## 🎯 Purpose

This document defines the **standard validation process** for all Conditional Access policies in this repository.

It ensures:

* Policies behave as expected
* No unintended access issues occur
* Safe transition from report-only to enforcement

## Before You Validate

Run deployment using the bootstrapper:

```powershell
cd "C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
```

Then validate policies in report-only mode.


---

# 🧭 Validation Phases

## Phase 1 — Deployment Validation

After deployment:

* Confirm policies exist in Entra
* Confirm state = Report-only

```powershell id="val1"
Get-MgIdentityConditionalAccessPolicy | Select DisplayName, State
```

---

## Phase 2 — Functional Testing

Test each policy individually using:

* Test user accounts
* Different devices
* Different client apps

---

## Phase 3 — Sign-in Log Analysis

Go to:

👉 Entra ID → Monitoring → Sign-in logs

### Filter by:

* User
* Application
* Conditional Access

---

## 🔍 What to Check

For each sign-in:

* Conditional Access tab
* Policies applied
* Report-only result
* Grant controls triggered

---

# 🧪 Policy Validation Matrix

| Policy            | What to Test         | Expected Result      |
| ----------------- | -------------------- | -------------------- |
| Require MFA       | Standard login       | MFA required         |
| Block Legacy      | Basic auth attempt   | Blocked              |
| Device Compliance | Non-compliant device | Block/flag           |
| Admin Protection  | Admin login          | MFA + device         |
| Session Controls  | Long session         | Reauth               |
| Location          | External IP          | Block                |
| User Risk         | Risky user           | MFA + password reset |
| Sign-in Risk      | Risky login          | MFA                  |

---

# 🧪 Risk-Based Testing

## User Risk

* Simulate compromised user
* Confirm password reset + MFA

## Sign-in Risk

* Use VPN / unusual location
* Confirm MFA triggered

---

# ⚠️ Critical Safety Checks

Before enforcement:

* Break-glass account excluded
* Admin accounts tested
* Service accounts validated
* No unexpected failures

---

# 🚨 High-Risk Indicators

DO NOT ENABLE policies if:

* Admin lockout risk detected
* Users unable to authenticate
* Critical apps impacted

---

# 🚀 Moving to Enforcement

Change:

```json id="val2"
"state": "enabledForReportingButNotEnforced"
```

To:

```json id="val3"
"state": "enabled"
```

---

## Recommended Order

1. Require MFA
2. Block legacy auth
3. Device compliance
4. Admin protection
5. Session controls
6. Risk policies
7. Location policies

---

# 🔐 Production Readiness Checklist

* [ ] All policies tested
* [ ] Sign-in logs validated
* [ ] No unexpected impact
* [ ] Break-glass configured
* [ ] Rollback plan defined

---

# 🔄 Continuous Validation

After enforcement:

* Monitor sign-in logs daily
* Review Conditional Access insights
* Adjust policies as needed

---

# 🎯 Goal

Ensure all Conditional Access policies:

* Enforce Zero Trust principles
* Maintain usability
* Prevent lockouts
* Provide strong identity protection
