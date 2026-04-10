# 🧪 Testing — User Risk Policy

## 🎯 Objective

Ensure users with **high user risk** are required to:

* Perform MFA
* Reset their password

This policy is part of Microsoft Entra **Identity Protection**.

---

## 🧠 What is User Risk?

User risk represents the likelihood that a user account is compromised based on signals such as:

* Leaked credentials
* Suspicious activity patterns
* Threat intelligence

---

## 👤 Test Scenarios

### Scenario 1 — High-Risk User (Simulated)

* User: Test account
* Risk Level: High

**Expected Result:**

* Policy is triggered
* User is required to:

  * Complete MFA
  * Perform password reset

---

### Scenario 2 — Normal User

* User: Standard user
* Risk Level: None

**Expected Result:**

* Policy is NOT triggered

---

## 🧪 How to Simulate User Risk

### Option 1 — Manual Risk Simulation (Recommended)

1. Go to:

   * Entra ID → Protection → **Identity Protection**
2. Select:

   * **Risky users**
3. Choose a test user
4. Click:

   * **Confirm user compromised**

---

## 🔍 How to Validate

1. Go to:

   * Entra ID → Monitoring → **Sign-in logs**
2. Filter:

   * User = test account
3. Open sign-in event
4. Check:

   * **Conditional Access tab**
   * Policy: *ZTCA - User Risk Policy*

---

## ✅ Success Criteria

* Policy is triggered for high-risk users
* Grant controls include:

  * MFA
  * Password change
* Policy shows as **Report-only (applied)**

---

## ⚠️ Failure Indicators

* Policy not triggered for risky user
* Password reset not required
* MFA not enforced

---

## 🚨 Important Notes

* Requires **Entra ID P2 license**
* Requires **Identity Protection enabled**
* Password reset must be combined with MFA

---

## 🚀 Ready for Enforcement?

* [ ] Tested with simulated risky user
* [ ] Policy triggered correctly
* [ ] No unexpected impact
* [ ] Break-glass account excluded

