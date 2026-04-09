.\deploy-policy.ps1

New-ZTConditionalAccessPolicy `
-DisplayName "ZTCA - Require MFA" `
-JsonPath ".\policies\01-require-mfa\policy.json"
