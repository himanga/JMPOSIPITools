param($AddinFile)

$tempLoad = Join-Path (Get-Location) "temp-loadaddin.jsl"
$AddinFullPath = Join-Path (Get-Location) $AddinFile

Set-Content $tempLoad "Open(`"$AddinFullPath`");`nQuit(`"No Save`";);"

$anyFailures = $false
$testedVersions = 0

foreach ($jmpExeVersion in $JmpVersionsToTest) {

    if ([string]::IsNullOrEmpty($jmpExeVersion)) {
        continue
    }

    if (-not (Test-Path $jmpExeVersion)) {
        Write-Host "`nSkipping $jmpExeVersion - not found"
        continue
    }

    Write-Host "`n====================================="
    Write-Host "Testing against $jmpExeVersion"
    Write-Host "====================================="

    Write-Output "Opening JMP to load add-in"
    Start-Process $jmpExeVersion -ArgumentList $tempLoad -NoNewWindow -Wait

    Write-Output "Opening JMP to run tests"
    $testScript = Join-Path (Get-Location) "Tests/RunTestsStandaloneQuitWhenDone.jsl"
    $tempfilePath = Join-Path $Env:TEMP "temp-unittestoutput.txt"

    Start-Process $jmpExeVersion -ArgumentList $testScript -NoNewWindow -Wait

    $result = Get-Content $tempfilePath -Raw | ConvertFrom-Json

    $ReportFailures = "-------------- Failures --------------" + (
        ($result.ReporterOutput -split '-------------- Failures --------------', 2)[1]
    )
    $ReportHeader = ($result.ReporterOutput -split '-----', 2)[0]

    Write-Host "`nUNIT TEST RESULTS - $jmpExeVersion"
    Write-Host $ReportFailures
    Write-Host $ReportHeader

    if ($result.TotalFailures -gt 0) {
        Write-Host "`nFAILED - $($result.TotalFailures) tests did not succeed"
        $anyFailures = $true
    } else {
        Write-Host "`nPASSED"
    }

    if (Test-Path $tempfilePath) {
        Remove-Item -Recurse -Force -Confirm:$false $tempfilePath
    }

    $testedVersions++
}

if ($testedVersions -eq 0) {
    Write-Host "`nWARNING: No JMP versions were found to test against."
} elseif ($anyFailures) {
    Write-Host "`n====================================="
    Write-Host "OVERALL: Unit tests failed across one or more JMP versions."
    Write-Host "This add-in is not ready for distribution."
    Write-Host "====================================="
} else {
    Write-Host "`n====================================="
    Write-Host "OVERALL: All tests passed across $testedVersions JMP version(s)."
    Write-Host "====================================="
}