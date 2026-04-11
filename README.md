# 🔐 Zero Trust Conditional Access Playbook

## ⚡ Quick Start (Recommended)

```powershell
cd "C:\Path\To\Zero-Trust-Conditional-Access-Playbook"
pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"

This runs the full deployment automatically:

installs prerequisites
connects to Microsoft Graph
creates named locations
deploys all policies
verifies results
🎯 Overview

This repository provides a policy-as-code implementation of Microsoft Entra Conditional Access aligned to Zero Trust principles.

It is designed to help organizations move from basic MFA enforcement → layered Zero Trust access control.

Included:

Conditional Access policy JSON definitions
PowerShell deployment scripts
Automated named location creation
Testing and validation procedures
A one-command bootstrap deployment method
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

Risk-based policies are not just configuration—they require investigation and response.

🔍 Where to Investigate
Identity Protection → Risky users
View users flagged as compromised
Identity Protection → Risk detections
Review events like:
leaked credentials
impossible travel
Monitoring → Sign-in logs
Analyze:
sign-in risk
Conditional Access results
applied policies
🛠️ Responding to Risk
User Risk (Compromised Accounts)
Require password reset
Require MFA
Confirm or dismiss risk
Sign-in Risk
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
🧪 Validation

After deployment, validate using:

docs/validation-playbook.md

Validation includes:

Sign-in log analysis
Risk simulation
Report-only evaluation
Enforcement readiness
⚙️ Execution

Primary method:

pwsh -ExecutionPolicy Bypass -File ".\scripts\bootstrap.ps1"

Additional script usage:

scripts/README.md
⚠️ Safety Requirements

Before enforcing policies:

Add break-glass account exclusions
Test admin/service accounts
Validate report-only results
Confirm no lockout scenarios
🔐 Zero Trust Alignment

This implementation enforces:

Verify explicitly
Use least privilege
Assume breach
🧪 Real-World Scenario

Credential theft attempt from unmanaged device

Without Conditional Access:

attacker gains access
session persists
lateral movement begins

With this playbook:

MFA is required → attacker challenged
device compliance enforced → access blocked
risk policies trigger → session revoked
session controls limit persistence

👉 This is where layered controls stop real attacks.
