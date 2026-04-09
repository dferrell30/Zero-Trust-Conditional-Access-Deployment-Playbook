How to run it

1) Install the module
Install-Module Microsoft.Graph -Scope CurrentUser

2) Connect to Graph

Connect-MgGraph -Scopes "Policy.Read.All"

4) Run the script
.\scripts\export\export-ca-config.ps1

Or with a timestamped export folder:

.\scripts\export\export-ca-config.ps1 -IncludeTimestampFolder

The Graph PowerShell docs show the Get-MgIdentityConditionalAccessNamedLocation and Get-MgIdentityConditionalAccessPolicy cmdlets for retrieving those objects.

What you get

Example output:

/exports
  /named-locations
    _index.json
    ZTCA - Trusted HQ__<id>.json
    ZTCA - Blocked Countries__<id>.json
  /conditional-access-policies
    _index.json
    ZTCA - Require MFA - All Users__<id>.json
    ZTCA - Block Legacy Authentication__<id>.json
