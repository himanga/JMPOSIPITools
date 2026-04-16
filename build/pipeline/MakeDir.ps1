<#
About: MakeDir Step

Creates the temporary build workspace by copying AddinFiles into
AddinFilesTempForBuild and stamping the build date into customMetadata.jsl.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"
. "$ProjectRoot/build/buildUtils.ps1"

Write-Host "Preparing build workspace..."

if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force $TempPath
}

New-Item -ItemType Directory -Path $TempPath | Out-Null

Copy-Item -Recurse "$AddinSource\*" $TempPath -ErrorAction Stop

$metaPath = Join-Path $TempPath $CustomMetadataRel

if (-not (Test-Path $metaPath)) {
    throw "Custom metadata file not found: $metaPath"
}

$stamp = Get-TimestampForJMP

(Get-Content $metaPath) `
    -replace 'List\( "buildDate", (\d+) \),', "List( `"buildDate`", $stamp )," |
    Set-Content $metaPath

Write-Host "Prepare step completed"