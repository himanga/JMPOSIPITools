<#
About: TzData Step

Downloads current IANA timezone data via tzBuilder.jsl and writes
AddinFiles/tz/tzData.jsl. Requires internet access.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. (Join-Path $ProjectRoot "build/buildConfig.ps1")

Write-Host "Building timezone data..."

$tzBuilderPath = Join-Path $ProjectRoot "AddinFiles/tz/tzBuilder.jsl"
$tzDataPath    = Join-Path $ProjectRoot "AddinFiles/tz/tzData.jsl"

$tempScript = Join-Path (Get-Location) "temp-buildtzdata.jsl"
$tzLogPath = Join-Path (Get-Location) "temp-buildtzdataLog.jsl"

Set-Content $tempScript @"
tzLogs = Log Capture(
    global:tzBuilderOutputPath = "$($tzDataPath -replace '\\', '/')";
    $TzDataPreJSL
    Include("$($tzBuilderPath -replace '\\', '/')");
    $TzDataPostJSL
);
Save Text File(
    "$tzLogPath",
    tzLogs
);
Quit("No Save");
"@

$beforeTime = Get-Date
Start-Process $JmpExe -ArgumentList $tempScript -Wait -NoNewWindow
#Remove-Item $tempScript -Force -ErrorAction SilentlyContinue

$fileInfo = Get-Item $tzDataPath -ErrorAction SilentlyContinue
if (-not $fileInfo -or $fileInfo.LastWriteTime -lt $beforeTime) {
    throw "tzData.jsl was not updated - check JMP output for errors"
}

$genLine = Get-Content $tzDataPath | Where-Object { $_ -match "Generated:" } | Select-Object -First 1
Write-Host "Timezone data generated successfully. $genLine"