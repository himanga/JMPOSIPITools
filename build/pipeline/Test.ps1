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
    $safeJmpName = $thisjmpExe -replace '[/:\\*?"<>| .]', '_'
    $pathRunTests = Join-Path $ProjectRoot "Tests/RunTestsStandalone.jsl"
    $pathTestsConfigDefault = Join-Path $ProjectRoot "Tests/testConfig.default.jsl"
    $pathTestsConfigLocal = Join-Path $ProjectRoot "Tests/testConfig.local.jsl"
    $pathTestScript = Join-Path (Get-Location) "temp-buildtestdata-$($safeJmpName).jsl"
    $pathTestOutput = Join-Path (Get-Location) "temp-buildtestdataOutput-$($safeJmpName).jsl"
    $pathTestLog = Join-Path (Get-Location) "temp-buildtestdataLog-$($safeJmpName).jsl"

Set-Content $pathTestScript @"
tzLogs = Log Capture(
    global:pathTestOutput = "$($pathTestOutput -replace '\\', '/')";
    Include( "$pathTestsConfigDefault" );
    If( File Exists( "$pathTestsConfigLocal" ),
        Include( "$pathTestsConfigLocal" )
    );
    Include("$($pathRunTests -replace '\\', '/')");
);
Save Text File(
    "$pathTestLog",
    tzLogs
);
Quit("No Save");
"@

    Start-Process $thisjmpExe -ArgumentList "`"$pathTestScript`"" -Wait -NoNewWindow

    if (-not (Test-Path $pathTestOutput)) {
        throw "Unit test output was not generated"
    }

    $result = Get-Content $pathTestOutput -Raw | ConvertFrom-Json
    $completeTime = [datetime]::ParseExact($result.'Complete Time', "yyyy-MM-ddTHH:mm:ss", $null)
    $elapsed = (Get-Date) - $completeTime
    
    # if ($elapsed.TotalSeconds -gt 30) {
    #     throw "Test output is stale ($([int]$elapsed.TotalSeconds) seconds old) - JMP may not have completed"
    # }

    $ReportFailures = "-------------- Failures --------------" + (
        ($result.ReporterOutput -split '-------------- Failures --------------', 2)[1]
    )
    $ReportHeader = ($result.ReporterOutput -split '-----', 2)[0]

    Write-Host "`nUNIT TEST RESULTS - $thisjmpExe"
    Write-Host "JMP Home Check: "$result.JMPHome
    Write-Host "Time since result: $($elapsed.TotalSeconds) seconds"
    Write-Host $ReportFailures
    Write-Host $ReportHeader

    if ($result.TotalFailures -gt 0) {
        Write-Host "`nFAILED - $($result.TotalFailures) tests did not succeed"
        $anyFailures = $true
    } else {
        Write-Host "`nPASSED"
    }

    $testedVersions++
}

if ($testedVersions -eq 0) {
    throw "No JMP versions available for testing"
}

if ($anyFailures) {
    throw "Unit tests failed on one or more JMP versions"
}

Write-Host "`n====================================="
Write-Host "OVERALL: All tests passed across $testedVersions JMP version(s)."
Write-Host "====================================="