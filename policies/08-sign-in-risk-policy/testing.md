# 🧪 Testing — Sign-in Risk Policy

## 🎯 Objective

Ensure users performing **risky sign-ins** are required to complete MFA.

---

## 🧠 What is Sign-in Risk?

Sign-in risk evaluates the likelihood that a specific login attempt is suspicious, based on:

* Impossible travel
* Anonymous IP usage
* Malware-linked IPs
* Unfamiliar sign-in properties

---

## 👤 Test Scenarios

### Scenario 1 — Risky Sign-in (Simulated)

* User: Test account
* Sign-in Risk: Medium or High

**Expected Result:**

* MFA is required

---

### Scenario 2 — Normal Sign-in

* User: Standard user
* Risk Level: Low

**Expected Result:**

* Policy is NOT triggered

---

## 🧪 How to Simulate Sign-in Risk

### Option 1 — Risk Simulation (Recommended)

1. Go to:

   * Entra ID → Protection → **Identity Protection**
2. Navigate to:

   * **Risk detections**
3. Use test account activity or simulate:

OR

### Option 2 — Realistic Testing

* Use:

  * VPN from different geographic region
  * Different device/browser

---

## 🔍 How to Validate

1. Go to:

   * Entra ID → Monitoring → **Sign-in logs**
2. Filter:

   * User = test account
3. Open sign-in event
4. Check:

   * **Conditional Access tab**
   * Policy: *ZTCA - Sign-in Risk Policy*

---

## ✅ Success Criteria

* Policy is triggered on risky sign-in
* MFA challenge is applied
* Policy appears in report-only results

---

## ⚠️ Failure Indicators

* Policy not triggered during risky sign-in
* MFA not enforced
* Incorrect risk level evaluation

---

## 🚨 Important Notes

* Requires **Entra ID P2 license**
* Depends on **Identity Protection signals**
* Risk signals may take time to appear

---

## ⚠️ Common Pitfalls

* Testing with no actual risk signal
* Expecting immediate detection
* Using accounts without sufficient activity

---

## 🚀 Ready for Enforcement?

* [ ] Tested with simulated risky sign-in
* [ ] MFA enforced correctly
* [ ] No unintended user impact
* [ ] Break-glass account excluded

---

## 🧪 Risk Simulation (PowerShell + Manual)

Microsoft does not currently provide a direct API to simulate user or sign-in risk.

Testing must be performed using a combination of:

* Manual risk simulation (recommended)
* PowerShell validation of results

---

## 🪜 Option 1 — Simulate User Risk (Recommended)

1. Go to:

   * Entra ID → Protection → **Identity Protection**
2. Select:

   * **Risky users**
3. Choose a test user
4. Click:

   * **Confirm user compromised**

This will trigger:

* User Risk = High
* Conditional Access policy evaluation

---

## 🪜 Option 2 — Generate Risk Signals (Advanced)

Use controlled test scenarios:

* Sign in from multiple geographic locations
* Use VPN from different regions
* Use different devices and browsers

---

## 🔍 Validate Using PowerShell

Run:

```powershell id="riskps1"
Get-MgAuditLogSignIn -Top 10 | Select-Object UserPrincipalName, RiskLevelDuringSignIn, RiskState, ConditionalAccessStatus
```

---

## 🎯 What to Look For

* RiskLevelDuringSignIn = medium/high
* ConditionalAccessStatus = success/failure
* Policy applied in report-only

---

## ⚠️ Limitations

* Risk detection is not immediate
* Depends on Microsoft threat intelligence
* Not all test activity will trigger risk

---

## 💡 Recommendation

Use:

* Manual simulation for validation
* PowerShell for verification


