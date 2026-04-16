<#
About: Cleanup Step

Removes the temporary build workspace created by the MakeDir step.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"

Write-Host "Cleaning up temporary files..."

if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force $TempPath
}

Write-Host "Cleanup completed"