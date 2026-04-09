# 🔐 Block Legacy Authentication

---

### Policy Summary

#### **Purpose:**

Eliminate authentication methods that bypass modern security controls.

---

#### **Activities Matching Criteria:**

* All users
* Legacy authentication clients

---

#### **Actions:**

* Block access

---

## 🎯 Use Cases

* Prevent IMAP/POP attacks
* Stop password spray via legacy protocols

---

## 🛡️ How This Protects Identity

* Removes **non-MFA capable authentication paths**
* Stops **automated credential attacks**

---

## ⚙️ Implementation

* Condition: Client Apps → Legacy Authentication
* Grant: Block

---

## 🧪 Testing

* Attempt login via legacy protocol
* Confirm block

---

## 🚀 Rollout Strategy

* Report-only first
* Identify impacted apps
* Enforce

---

