$repoRoot = Resolve-Path "$PSScriptRoot\..\.."
$policyRoot = Join-Path $repoRoot "policies"
$helperScript = Join-Path $repoRoot "scripts\deployment\deploy-policy.ps1"

. $helperScript

Write-Host "Starting bulk deployment..."

$policyFiles = Get-ChildItem -Path $policyRoot -Recurse -Filter policy.json

foreach ($file in $policyFiles) {
    $folder = Split-Path $file.FullName -Parent
    $name = Split-Path $folder -Leaf

    Write-Host "Deploying policy: $name"

    New-ZTConditionalAccessPolicy `
        -DisplayName $name `
        -JsonPath $file.FullName `
        -SkipIfExists
}

Write-Host "Bulk deployment complete."
