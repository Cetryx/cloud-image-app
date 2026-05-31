. "$PSScriptRoot\set-path.ps1"

$projectRoot = Split-Path -Parent $PSScriptRoot
$terraformDir = Join-Path $projectRoot "terraform"

Write-Output "Switching to Terraform directory:"
Write-Output $terraformDir

Set-Location $terraformDir

terraform fmt
terraform validate
terraform apply -var-file="main.tfvars"