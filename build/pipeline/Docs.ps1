<#
About: Docs Step

Generates HTML documentation from NaturalDocs comments and converts
README.md and CHANGELOG.md to HTML. Outputs into the temp build folder.

Section: Globals
#>
param(
    [Parameter(Mandatory)]
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

. "$ProjectRoot/build/buildConfig.ps1"
. "$ProjectRoot/build/buildUtils.ps1"

if (-not $TempPath) {
    throw "TempPath is not defined"
}
if (-not (Test-Path $NaturalDocsExe)) {
    throw "NaturalDocs not found at $NaturalDocsExe"
}

Write-Host "Generating documentation..."

& $NaturalDocsExe "NaturalDocs" -r

if (-not (Get-Module -ListAvailable MarkdownToHtml)) {
    Install-Module MarkdownToHtml -Scope CurrentUser -Force
}
Import-Module MarkdownToHtml

Convert-MarkdownToHtml -Path "README.md" `
    -Template "MarkdownTemplate/" `
    -SiteDirectory $TempPath `
    -ErrorAction Stop

Convert-MarkdownToHtml -Path "CHANGELOG.md" `
    -Template "MarkdownTemplate/" `
    -SiteDirectory $TempPath `
    -ErrorAction Stop

Copy-Item "LICENSE" "$TempPath\LICENSE.txt" -Force -ErrorAction Stop

Write-Host "Docs generation completed"