param(
  [string]$ResourceGroupName = "rg-cloud-image-app-tf",
  [string]$WebAppName = "app-cloud-img-tf-u94m0d"
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$appDir = Join-Path $projectRoot "app"
$deployDir = Join-Path $projectRoot ".deploy"
$zipPath = Join-Path $deployDir "cloud-image-app.zip"

if (-not (Test-Path $appDir)) {
  Write-Error "App directory not found: $appDir"
  exit 1
}

if (-not (Test-Path $deployDir)) {
  New-Item -ItemType Directory -Path $deployDir | Out-Null
}

if (Test-Path $zipPath) {
  Remove-Item -LiteralPath $zipPath
}

Write-Output "Packaging application..."
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($zipPath, [System.IO.Compression.ZipArchiveMode]::Create)
$appRoot = (Resolve-Path $appDir).Path.TrimEnd("\")

try {
  Get-ChildItem -Path $appDir -Recurse -File |
    Where-Object {
      $_.FullName -notmatch "__pycache__" -and
      $_.Extension -ne ".pyc"
    } |
    ForEach-Object {
      $relativePath = $_.FullName.Substring($appRoot.Length + 1)
      $entryName = $relativePath.Replace("\", "/")
      [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $entryName) | Out-Null
    }
}
finally {
  $zip.Dispose()
}

Write-Output "Deploying application package to Azure App Service..."
az webapp deploy `
  --resource-group $ResourceGroupName `
  --name $WebAppName `
  --src-path $zipPath `
  --type zip `
  --clean true

Write-Output "Deployment complete."
