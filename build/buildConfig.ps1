<#
About: Build Configuration

Default configuration values for the build pipeline. Override any
value locally by creating build/buildConfig.local.ps1 (gitignored).

Section: Globals
#>
$AddinSource       = "AddinFiles"
$TempPath          = "AddinFilesTempForBuild"
$CustomMetadataRel = "customMetadata.jsl"

$NaturalDocsExe = "C:\Program Files (x86)\Natural Docs\NaturalDocs.exe"
$JmpExe         = "$Env:ProgramFiles\JMP\JMPPRO\19\jmp.exe"

# Optional JSL to run before and after tzBuilder.jsl
# Override in buildConfig.local.ps1 to configure proxy or other local setup
$TzDataPreJSL  = ""
$TzDataPostJSL = ""

# JMP versions to run unit tests against in build_Release.ps1.
# Set any entry to "" to skip it, or override the whole array in
# buildConfig.local.ps1 to add/remove versions.
$JmpVersionsToTest = @(
    "$Env:ProgramFiles\JMP\JMPPRO\18\jmp.exe",
    "$Env:ProgramFiles\JMP\JMPPRO\19\jmp.exe"
)

# Apply local overrides if the file exists
$configDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path $MyInvocation.MyCommand.Path -Parent }
$localConfig = Join-Path $configDir "buildConfig.local.ps1"
if (Test-Path $localConfig) {
    . $localConfig
}