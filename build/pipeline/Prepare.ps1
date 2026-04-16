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
Remove-Item "$ProjectRoot/build/.last_addin" -Force -ErrorAction SilentlyContinue

Write-Host "Prepared folders for a new run"