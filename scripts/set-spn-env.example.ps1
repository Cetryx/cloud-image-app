# Copy this file to scripts/set-spn-env.ps1 and fill in the real Service Principal values.
# Do not commit scripts/set-spn-env.ps1 because it contains a client secret.

$env:ARM_CLIENT_ID = "00000000-0000-0000-0000-000000000000"
$env:ARM_CLIENT_SECRET = "replace-with-client-secret"
$env:ARM_TENANT_ID = "00000000-0000-0000-0000-000000000000"
$env:ARM_SUBSCRIPTION_ID = "00000000-0000-0000-0000-000000000000"

Write-Output "Terraform Service Principal environment variables are set for this terminal session."
