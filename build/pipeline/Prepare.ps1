<#
About: Prepare Step

Clears the .last_addin marker file to ensure a clean run. Should
always be the first step in any preset.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"

Remove-Item "$ProjectRoot/build/.last_addin" -Force -ErrorAction SilentlyContinue

# Remove any leftover temp files from a previous failed build
Get-ChildItem -Path $ProjectRoot -Filter "temp-*" -File | ForEach-Object {
    Write-Host "Removing leftover temp file: $($_.Name)"
    Remove-Item $_.FullName -Force
}

if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force $TempPath
}

Write-Host "Prepared folders for a new run"