Push-Location $PSScriptRoot
$scriptDir = Resolve-Path $PSScriptRoot
Pop-Location

$projectRoot = if ((Split-Path $PSScriptRoot -Leaf) -ieq 'build') {
    Split-Path $scriptDir -Parent
}

$projectRoot = if ((Split-Path $PSScriptRoot -Leaf) -ieq 'build') {
    Split-Path $scriptDir -Parent
}

. "$projectRoot\build\buildUtils.ps1"
. "$projectRoot\build\buildConfig.ps1"
. "$projectRoot\build\buildPrepare.ps1"
. "$projectRoot\build\buildDocs.ps1"
$addin = . "$scriptDir\buildPackage.ps1"
. "$projectRoot\build\buildCleanup.ps1"

#Try to open in the current instance of JMP - will not always work
Invoke-Item "$projectRoot\$addin"
#Invoke-Item (Join-Path (Get-Location) $addin)

#Start-Process $JmpExe -ArgumentList (Join-Path (Get-Location) $addin) -NoNewWindow
Write-Host "`nQuick build/deploy completed: $addin"
