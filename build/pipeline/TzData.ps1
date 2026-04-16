param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"

Write-Host "Building timezone data..."

$tzBuilder = Join-Path $ProjectRoot "AddinFiles/tz/tzBuilder.jsl"
$tzData    = Join-Path $ProjectRoot "AddinFiles/tz/tzData.jsl"

$tempScript = Join-Path (Get-Location) "temp-buildtzdata.jsl"

Set-Content $tempScript @"
tzBuilderOutputPath = `"$($tzData -replace '\\', '\\\\')`";
Include(`"$($tzBuilder -replace '\\', '\\\\')`");
"@

Start-Process $JmpExe -ArgumentList $tempScript -Wait -NoNewWindow

Remove-Item $tempScript -Force -ErrorAction SilentlyContinue

if (-not (Test-Path $tzData)) {
    throw "tzData.jsl was not created"
}

Write-Host "Timezone data generated successfully"