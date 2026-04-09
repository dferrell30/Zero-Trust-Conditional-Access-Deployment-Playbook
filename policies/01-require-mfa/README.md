
---

# 🔐 POLICY 01 — REQUIRE MFA

`/policies/01-require-mfa/README.md`

:::writing{variant="standard" id="ztca2"}
# 🔐 Require MFA for All Users

---

## 📌 Overview

This policy enforces **multi-factor authentication (MFA)** across all users and applications.

---

### Policy Summary

#### **Purpose:**  
Prevent credential-based attacks by requiring strong authentication.

---

#### **Activities Matching Criteria:**  
- All users (exclude break-glass)
- All cloud apps

---

#### **Actions:**  
- Require MFA

---

#### **Alerts:**  
- Monitor failed MFA attempts in sign-in logs

---

#### **Impact Summary:**

**For Users:**  
- Additional authentication step required

**For the Organization:**  
- Blocks password spray and phishing attacks

---

## 🎯 Use Cases

- Organization-wide baseline security
- Remote workforce protection
- Compliance enforcement

---

## 🛡️ How This Protects Identity

- Prevents **credential theft attacks**
- Mitigates **password reuse risk**
- Adds **second factor validation**

---

## ⚙️ Implementation

1. Go to Conditional Access
2. New Policy → “Require MFA – All Users”
3. Assign:
   - Users: All users (exclude emergency accounts)
   - Apps: All cloud apps
4. Grant:
   - Require MFA

---

## 🧪 Testing

- Test login from:
  - New browser
  - External network
- Validate MFA prompt appears

---

## 🚀 Rollout Strategy

- Start in **Report-only**
- Validate logs
- Move to **On**

---

## 📄 JSON

```json
{
  "grantControls": ["mfa"]
}
