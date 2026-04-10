# 🧪 Testing — Location Policy

## 🎯 Objective

Restrict access from untrusted locations.

---

## 👤 Test Scenario

* Login from:

  * Trusted location
  * Non-trusted location

---

## Expected

* Trusted → allowed
* Untrusted → blocked (report-only)

---

## ⚠️ Watch For

* VPN behavior
* IP misclassification

