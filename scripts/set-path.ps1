Write-Output "Preparing Terraform path..."
Write-Output "This script adds Terraform to the current terminal PATH."

$terraformPath = "C:\Program Files (x86)\Terraform"
$terraformExe = Join-Path $terraformPath "terraform.exe"

Write-Output "Checking Terraform at:"
Write-Output $terraformExe

if (-not (Test-Path $terraformExe)) {
  Write-Output "Terraform was not found at this path."
  exit 1
}

Write-Output "Terraform found."

if ($env:Path -notlike "*$terraformPath*") {
  $env:Path += ";$terraformPath"
  Write-Output "Terraform path added to current terminal session."
}
else {
  Write-Output "Terraform path is already available in this terminal session."
}

Write-Output ""
Write-Output "Terraform version:"
terraform --version
