$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptRoot "..\..\..")
$helperScript = Join-Path $repoRoot "scripts\deployment\deploy-policy.ps1"
$policyJson = Join-Path $scriptRoot "policy.json"

. $helperScript

New-ZTConditionalAccessPolicy `
    -DisplayName "ZTCA - Sign-in Risk Policy" `
    -JsonPath $policyJson
