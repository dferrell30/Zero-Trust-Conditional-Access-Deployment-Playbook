# 🧪 Testing — Require MFA

## 🎯 Objective

Ensure all users are prompted for MFA when accessing cloud apps.

---

## 👤 Test Scenarios

### Scenario 1 — Standard User Login

* User: Standard user
* App: Office 365
* Device: Any

**Expected Result:**

* MFA prompt appears

---

### Scenario 2 — Browser vs Desktop

* Test both:

  * Browser login
  * Outlook / Teams client

**Expected Result:**

* MFA required in both

---

## 🔍 Validation

* Check Sign-in logs → Conditional Access
* Confirm:

  * Policy applied
  * Grant = MFA

---

## ✅ Success Criteria

* MFA required for all users
* No service account failures

---

## ⚠️ Watch For

* Service accounts breaking
* Legacy auth bypassing MFA

