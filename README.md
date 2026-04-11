🔐 Zero Trust Conditional Access Playbook
⚡ Quick Start

Run the bootstrapper to install prerequisites, connect to Microsoft Graph, create named locations, deploy policies, and verify results.

cd "C:\Path\To\Zero-Trust-Conditional-Access-Playbook"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"
🎯 Overview

This repository provides a policy-as-code implementation of Microsoft Entra Conditional Access aligned to Zero Trust principles.

It is designed to help organizations move from basic MFA enforcement to a layered Zero Trust access model.

Included in this repository:

Conditional Access policy JSON definitions
PowerShell deployment scripts
Automated named location creation
Testing and validation procedures
A one-command bootstrap deployment method
👥 Who This Is For

This playbook is designed for:

Microsoft Entra administrators
Identity and access engineers
Security architects
Microsoft 365 / Zero Trust practitioners
Teams building a production-ready Conditional Access baseline

This repository is especially useful for organizations that want to move from basic MFA enforcement to a layered Zero Trust access model using identity, device, location, and session signals.

🧱 Architecture
policies/     → Conditional Access policies (JSON + docs)
scripts/      → Deployment, bootstrap, and automation
docs/         → Validation and implementation guides
images/       → Screenshots and diagrams
🔐 Core Policies (Entra P1)
Policy	Purpose
Require MFA	Enforce MFA across all users
Block Legacy Auth	Block basic authentication
Device Compliance	Require compliant devices
Admin Protection	Stronger controls for admins
Session Controls	Manage session lifetime
Location Policy	Restrict risky locations
🧠 Identity Protection (Entra P2)
Policy	Purpose
User Risk Policy	Respond to compromised accounts
Sign-in Risk Policy	Respond to risky sign-ins
🧠 Identity Protection — Operational Readiness

Risk-based policies are not just configuration. They require investigation and response.

🔍 Where to Investigate
Identity Protection → Risky users
View users flagged as potentially compromised
Identity Protection → Risk detections
Review events such as:
leaked credentials
impossible travel
Monitoring → Sign-in logs
Review:
sign-in risk
Conditional Access results
applied policies
🛠️ Responding to Risk
User Risk

When a user is flagged as high risk:

Require password reset
Require MFA verification
Confirm or dismiss the risk
Sign-in Risk

When a risky sign-in is detected:

Require MFA challenge
Block high-risk attempts
Investigate:
location anomalies
device context
sign-in patterns
⚠️ Before Enabling Risk Policies
Validate policies in report-only mode
Ensure remediation workflows are understood
Test with non-production users
Confirm P2 licensing is available
⚙️ Recommended Execution Method

Use the bootstrapper as the primary execution method.

cd "C:\Users\<YourName>\Documents\Github\Zero-Trust-Conditional-Access-Playbook-main"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"

For additional script usage, see:

scripts/README.md
🧪 Validation

Use the validation guide after deployment:

docs/validation-playbook.md

Validation includes:

Sign-in log analysis
Risk simulation
Report-only verification
Enforcement readiness checks
⚠️ Safety Requirements

Before enabling policies:

Add break-glass account exclusions
Validate all policies in report-only mode
Test admin and service accounts
Confirm no lockout scenarios
🔐 Zero Trust Alignment

This repo enforces:

Verify explicitly
Use least privilege
Assume breach
🧪 Real-World Scenario

Credential theft attempt from an unmanaged device

Without Conditional Access:

attacker gains access
session persists
lateral movement begins

With this playbook:

MFA is required → attacker challenged
device compliance enforced → access blocked
risk policies trigger → session revoked
session controls limit persistence

This is where layered Zero Trust controls stop real attacks.

📌 Status
✅ MVP Complete
✅ Bootstrap Automation Working
✅ Validation Ready
⚠️ Requires production hardening before enforcement
🎯 Goal

Provide a repeatable, auditable, and scalable Conditional Access deployment model.

🔁 Safe to Re-Run

This deployment is idempotent.

You can safely run the bootstrapper multiple times:

pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"

Existing policies and named locations will be updated instead of duplicated.

⚠️ Disclaimer

This tool is provided for educational, testing, and security validation purposes only.

Use of this tool should be limited to:

authorized environments
lab or approved enterprise systems

The author assumes no liability or responsibility for:

misuse of this tool
damage to systems
unauthorized or improper use

By using this tool, you agree to use it in a lawful and responsible manner.

This project is not affiliated with or endorsed by Microsoft.

⚖️ Professional Disclaimer

This project is an independent work developed in a personal capacity.

The views, opinions, code, and content expressed in this repository are solely my own and do not reflect the views, policies, or positions of any current or future employer, client, or affiliated organization.

No employer, past, present, or future, has reviewed, approved, endorsed, or is in any way associated with these works.

This project was developed outside the scope of any employment and without the use of proprietary, confidential, or restricted resources.

All code and language in this repository are provided under the terms of the included MIT License.
