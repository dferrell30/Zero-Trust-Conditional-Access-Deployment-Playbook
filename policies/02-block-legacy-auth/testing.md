# 🧪 Testing — Block Legacy Authentication

## 🎯 Objective

Block all legacy authentication protocols.

---

## 👤 Test Scenarios

### Scenario 1 — Legacy Attempt

* Use:

  * Old Outlook client
  * Basic auth script

**Expected Result:**

* Access is blocked

---

## 🔍 Validation

* Sign-in logs:

  * Client App = “Other” or “Exchange ActiveSync”

---

## ✅ Success Criteria

* Legacy auth attempts are blocked

---

## ⚠️ Watch For

* Older apps still in use
* Scripts using basic auth

