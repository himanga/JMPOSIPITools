<#
About: Quick Preset

Fast development build. Skips timezone rebuild and unit tests.
Opens the resulting add-in in JMP automatically.

Section: Globals
#>
@{
    Steps = @(
        'Prepare',
        'MakeDir'
        'Docs'
        'Package'
        'Cleanup'
    )
}