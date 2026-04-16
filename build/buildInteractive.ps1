<#
About: Interactive Build Launcher

Presents a timed key-press menu to select a build preset, then
invokes build.ps1 with the selected preset. If Custom is chosen,
prompts the user to toggle individual pipeline steps on or off.

Section: Preset Selection
#>
$ErrorActionPreference = 'Stop'

$scriptDir   = Resolve-Path $PSScriptRoot
$projectRoot = Split-Path $scriptDir -Parent
$buildScript = Join-Path $scriptDir 'build.ps1'

$presetName = 'Quick'

# Only interact if we have a real console
if ($Host.UI -and $Host.UI.RawUI) {

    Write-Host ''
    Write-Host 'Quick build starting...'
    Write-Host 'Press [R] = Full Release'
    Write-Host 'Press [C] = Custom (choose steps)'
    Write-Host 'Waiting 3 seconds before automatically starting quick build...'

    $timeoutMs = 3000
    $start = Get-Date

    while (((Get-Date) - $start).TotalMilliseconds -lt $timeoutMs) {
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true).Key

            switch ($key) {
                'R' { $presetName = 'Release';     break }
                'C' { $presetName = 'Custom';      break }
            }
            break
        }
        Start-Sleep -Milliseconds 50
    }
}

Write-Host "`nSelected build preset: $presetName"
Write-Host "--------------------------------"

<#
Group: Custom Step Selection

Prompts the user to toggle individual pipeline steps on or off by
number. All steps are selected by default. Steps always run in the
canonical order defined in $allSteps regardless of selection order.
#>
$customSteps = $null
if ($presetName -eq 'Custom') {

    $allSteps = @('Prepare', 'MakeDir', 'Docs', 'Package', 'Test', 'Cleanup')
    $selected = @{}
    foreach ($step in $allSteps) { $selected[$step] = $true }

    Write-Host ''
    Write-Host 'Custom build - toggle steps on/off.'
    Write-Host 'All steps are selected by default.'
    Write-Host 'Type a number to toggle, or press Enter to continue.'
    Write-Host ''

    $done = $false
    while (-not $done) {
        Write-Host 'Current selection:'
        for ($i = 0; $i -lt $allSteps.Count; $i++) {
            $step   = $allSteps[$i]
            $marker = if ($selected[$step]) { '[X]' } else { '[ ]' }
            Write-Host ("  [{0}] {1} {2}" -f ($i + 1), $marker, $step)
        }
        Write-Host ''
        $input = Read-Host 'Number to toggle, or Enter to continue'

        if ([string]::IsNullOrWhiteSpace($input)) {
            $done = $true
        } else {
            $num = 0
            if ([int]::TryParse($input, [ref]$num) -and $num -ge 1 -and $num -le $allSteps.Count) {
                $step = $allSteps[$num - 1]
                $selected[$step] = -not $selected[$step]
            } else {
                Write-Host "  Please enter a number between 1 and $($allSteps.Count)."
            }
        }
    }

    $customSteps = $allSteps | Where-Object { $selected[$_] }

    if ($customSteps.Count -eq 0) {
        Write-Host 'No steps selected, exiting.'
        exit 0
    }

    Write-Host ''
    Write-Host "Steps to run: $($customSteps -join ', ')"
    Write-Host '--------------------------------'
}

<#
Group: Execution

Invokes build.ps1 with the selected preset or custom step list.
Opens the resulting add-in in JMP automatically for Quick builds.
#>
if ($customSteps) {
    & $buildScript -Preset 'Custom' -Steps $customSteps
} else {
    & $buildScript -Preset ([string]$presetName)
}

if ($presetName -eq 'Quick') {
    $addin = Get-Content "$projectRoot\build\.last_addin" -ErrorAction Stop
    Write-Host '=== Opening in JMP ==='
    Invoke-Item "$projectRoot\$addin"
}

exit $LASTEXITCODE