⚙️ 1. PowerShell Setup (Step-by-Step)

📥 Install PowerShell (if needed)

Install PowerShell 7
👉 https://aka.ms/powershell
📦 Install Required Modules

Run PowerShell as Administrator:

Install-Module Microsoft.Graph -Scope CurrentUser
🔐 Required Permissions (IMPORTANT)

You’ll need:

Policy.ReadWrite.ConditionalAccess
Directory.Read.All
Application.Read.All

🔑 Connect to Microsoft Graph

```Powershell
Connect-MgGraph -Scopes `
"Policy.ReadWrite.ConditionalAccess",
"Directory.Read.All",
"Application.Read.All"
```

Verify:

```Powershell
Get-MgContext
```


🧱 2. Reusable Policy Deployment Framework

(/scripts/deploy-policy.ps1):

```Powershell
function New-ZTConditionalAccessPolicy {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DisplayName,

        [Parameter(Mandatory=$true)]
        [string]$JsonPath
    )

    Write-Host "Creating policy: $DisplayName"

    $json = Get-Content $JsonPath -Raw | ConvertFrom-Json

    New-MgIdentityConditionalAccessPolicy -BodyParameter $json

    Write-Host "Policy created successfully: $DisplayName"
}
```
---

🪜 Step 1 — Open PowerShell

Run as Administrator

🪜 Step 2 — Connect to Graph
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

🪜 Step 3 — Navigate to Repo
cd C:\GitHub\entra-zero-trust-conditional-access

🪜 Step 4 — Import Script
. .\scripts\deploy-policy.ps1

🪜 Step 5 — Deploy Policies
Single policy:

New-ZTConditionalAccessPolicy `
-DisplayName "ZTCA - Require MFA" `
-JsonPath ".\policies\01-require-mfa\policy.json"

All policies:
.\deploy-all.ps1

🪜 Step 6 — Verify
Get-MgIdentityConditionalAccessPolicy

⚠️ Critical Notes (Production)

Always:
- Exclude break-glass accounts
- Start in Report-only mode
- Validate via Sign-in Logs

Replace:
- <BREAK_GLASS_OBJECT_ID>
- <TRUSTED_LOCATION_ID>
