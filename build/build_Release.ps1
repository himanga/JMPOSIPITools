
try {
    # Save current location and switch to script's directory
    Push-Location $PSScriptRoot
    $scriptDir = Resolve-Path $PSScriptRoot
}
finally {
    # Restore original location
    Pop-Location
}

try {
    $projectRoot = if ((Split-Path $PSScriptRoot -Leaf) -ieq 'build') {
        Split-Path $scriptDir -Parent
    }

    . "$projectRoot\build\buildUtils.ps1"
    . "$projectRoot\build\buildConfig.ps1"
    . "$projectRoot\build\buildPrepare.ps1"
    . "$projectRoot\build\buildDocs.ps1"
    $addin = . "$projectRoot\build\buildPackage.ps1"
    . "$projectRoot\build\buildTest.ps1" $addin
    . "$projectRoot\build\buildCleanup.ps1"

    Write-Host "`nRelease build completed: $addin"
    Write-Host "`nbuildDate: "$updatetime
}
catch {
    $_ | Format-List * -Force
    exit 1
}