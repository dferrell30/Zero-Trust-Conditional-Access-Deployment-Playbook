# 🌍 Named Locations

This folder contains scripts and guidance for creating **trusted locations** used by Conditional Access policies.

---

## ⚠️ Important

This repository does NOT include real IP addresses.

Example IP ranges shown in documentation are:

* Reserved for documentation (RFC 5737)
* NOT routable
* NOT valid for production use

Replace placeholder values with your real IP ranges.

If left empty:

* trusted locations will not be configured
* location-based policies may block all users when enforced

---

## 🛠️ What You Must Do

Before using location-based policies:

1. Replace placeholder values with your organization's real IP ranges
2. Include:

   * Office public IPs
   * VPN egress IPs
   * Proxy / security provider IPs

---

## 🔐 Why This Matters

Location-based policies rely on trusted IPs.

If misconfigured:

* You may block all users
* You may bypass security controls

---

## ✅ Best Practice

* Always test in report-only mode
* Validate using sign-in logs
* Confirm trusted location detection before enforcement
