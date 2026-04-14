# build/buildConfig.ps1
# Default build configuration.
#
# To override settings for your local environment, copy any relevant lines
# from this file to  build/buildConfig.local.ps1 (gitignored). Any variable
# reassigned there will take precedence over the defaults here.
$AddinSource       = "AddinFiles"
$TempPath          = "AddinFilesTempForBuild"
$CustomMetadataRel = "customMetadata.jsl"

$NaturalDocsExe = "C:\Program Files (x86)\Natural Docs\NaturalDocs.exe"
$JmpExe         = "$Env:ProgramFiles\JMP\JMPPRO\19\jmp.exe"

# JMP versions to run unit tests against in build_Release.ps1.
# Set any entry to "" to skip it, or override the whole array in
# buildConfig.local.ps1 to add/remove versions.
$JmpVersionsToTest = @(
    "$Env:ProgramFiles\JMP\JMPPRO\18\jmp.exe",
    "$Env:ProgramFiles\JMP\JMPPRO\19\jmp.exe"
)

# Apply local overrides if the file exists
$localConfig = Join-Path $PSScriptRoot "buildConfig.local.ps1"
if (Test-Path $localConfig) {
    . $localConfig
}