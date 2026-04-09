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
