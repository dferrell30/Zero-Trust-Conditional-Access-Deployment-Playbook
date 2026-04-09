$policies = @(
    ".\policies\01-require-mfa\policy.json",
    ".\policies\02-block-legacy-auth\policy.json",
    ".\policies\03-device-compliance\policy.json",
    ".\policies\04-admin-protection\policy.json",
    ".\policies\05-session-controls\policy.json",
    ".\policies\06-location-based\policy.json",
    ".\policies\p2\07-user-risk-policy\policy.json",
    ".\policies\p2\08-signin-risk-policy\policy.json"
)

foreach ($policy in $policies) {
    New-ZTConditionalAccessPolicy -DisplayName $policy -JsonPath $policy
}
