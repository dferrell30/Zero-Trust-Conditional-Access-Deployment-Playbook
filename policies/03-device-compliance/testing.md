# 🧪 Testing — Device Compliance

## 🎯 Objective

Ensure only compliant devices can access resources.

---

## 👤 Test Scenarios

### Scenario 1 — Compliant Device

* Device: Intune compliant

**Expected Result:**

* Access allowed

---

### Scenario 2 — Non-Compliant Device

* Device: Not compliant

**Expected Result:**

* Access restricted (report-only shows block)

---

## 🔍 Validation

* Sign-in logs → Device detail

---

## ⚠️ Watch For

* Users not enrolled in Intune
* BYOD scenarios

