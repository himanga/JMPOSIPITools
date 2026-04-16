<#
About: Test Step

Loads the packaged add-in into each configured JMP version and runs
the unit test suite. Fails the build if any tests fail or if no JMP
versions are found.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"

$addinFile = Get-Content "$ProjectRoot/build/.last_addin" -ErrorAction Stop
$addinFullPath = Join-Path (Get-Location) $addinFile

$tempLoad = Join-Path (Get-Location) "temp-loadaddin.jsl"
Set-Content $tempLoad "Open(`"$addinFullPath`");`nQuit(`"No Save`";);"

$anyFailures = $false
$testedVersions = 0

foreach ($thisjmpExe in $JmpVersionsToTest) {

    if ([string]::IsNullOrWhiteSpace($thisjmpExe)) { continue }
    if (-not (Test-Path $thisjmpExe)) {
        Write-Host "Skipping $thisjmpExe (not found)"
        continue
    }

    Write-Host "`n====================================="
    Write-Host "Testing against $thisjmpExe"
    Write-Host "====================================="

    Write-Output "Opening JMP to load add-in"
    Start-Process $thisjmpExe -ArgumentList $tempLoad -Wait -NoNewWindow

    Write-Output "Opening JMP to run tests"
    $testScript = Join-Path (Get-Location) "Tests/RunTestsStandaloneQuitWhenDone.jsl"
    $resultPath = Join-Path $env:TEMP "temp-unittestoutput.txt"

    Start-Process $thisjmpExe -ArgumentList $testScript -Wait -NoNewWindow

    if (-not (Test-Path $resultPath)) {
        throw "Unit test output was not generated"
    }

    $result = Get-Content $resultPath -Raw | ConvertFrom-Json

    $ReportFailures = "-------------- Failures --------------" + (
        ($result.ReporterOutput -split '-------------- Failures --------------', 2)[1]
    )
    $ReportHeader = ($result.ReporterOutput -split '-----', 2)[0]

    Write-Host "`nUNIT TEST RESULTS - $thisjmpExe"
    Write-Host $ReportFailures
    Write-Host $ReportHeader

    if ($result.TotalFailures -gt 0) {
        Write-Host "`nFAILED - $($result.TotalFailures) tests did not succeed"
        $anyFailures = $true
    } else {
        Write-Host "`nPASSED"
    }

    Remove-Item $resultPath -Force -ErrorAction SilentlyContinue
    $testedVersions++
}

Remove-Item $tempLoad -Force -ErrorAction SilentlyContinue

if ($testedVersions -eq 0) {
    throw "No JMP versions available for testing"
}

if ($anyFailures) {
    throw "Unit tests failed on one or more JMP versions"
}

Write-Host "`n====================================="
Write-Host "OVERALL: All tests passed across $testedVersions JMP version(s)."
Write-Host "====================================="