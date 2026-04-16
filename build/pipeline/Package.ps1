<#
About: Package Step

Compresses the temporary build workspace into a .jmpaddin file and
writes the output filename to build/.last_addin for downstream steps.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"
. "$ProjectRoot/build/buildUtils.ps1"

Write-Host "Packaging add-in..."

$meta = Get-CustomMetadata (Join-Path $TempPath $CustomMetadataRel)

$FileBase  = "JMPOSIPITools_{0}_{1}" -f $meta.Version, $meta.State
$ZipFile   = "$FileBase.zip"
$AddinFile = "$FileBase.jmpaddin"

Remove-Item $ZipFile, $AddinFile -Force -ErrorAction SilentlyContinue

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    (Resolve-Path $TempPath),
    (Join-Path (Get-Location) $ZipFile),
    [System.IO.Compression.CompressionLevel]::Fastest,
    $false
)

Rename-Item $ZipFile $AddinFile

# Persist addin path for downstream steps
Set-Content "$ProjectRoot/build/.last_addin" $AddinFile

Write-Host "Packaged: $AddinFile"