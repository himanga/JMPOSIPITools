<#
About: Build Orchestrator

Runs build steps defined in a preset file or a custom list of steps.
Each step is a script in build/pipeline/ that accepts -ProjectRoot.

Presets are defined in build/presets/ as .psd1 files. The Custom preset
requires steps to be passed explicitly via -Steps.

Section: Globals
#>
[CmdletBinding()]
param(
    [string]$Preset = 'Quick',
    [string[]]$Steps = @()
)

$ErrorActionPreference = 'Stop'

$allowedPresets = @('Quick', 'Release', 'Custom')
if ($Preset -notin $allowedPresets) {
    throw "Invalid preset '$Preset'. Allowed: $($allowedPresets -join ', ')"
}

$scriptDir   = Resolve-Path $PSScriptRoot
$projectRoot = Split-Path $scriptDir -Parent
$pipeline    = Join-Path $scriptDir 'pipeline'

# Determine steps to run
if ($Preset -eq 'Custom') {
    if ($Steps.Count -eq 0) {
        throw "Preset 'Custom' requires -Steps to be specified."
    }
    $stepsToRun = $Steps
} else {
    $presetFile = Join-Path $scriptDir "presets/$Preset.psd1"
    if (-not (Test-Path $presetFile)) {
        throw "Preset file not found: $presetFile"
    }
    $presetConfig = Import-PowerShellDataFile $presetFile
    $stepsToRun   = $presetConfig.Steps
}

function Invoke-Step {
    param([string]$Name)

    $stepPath = Join-Path $pipeline "$Name.ps1"
    if (-not (Test-Path $stepPath)) {
        throw "Step script not found: $stepPath"
    }
    Write-Host "`n=== $Name ==="
    & $stepPath -ProjectRoot $projectRoot
}

try {
    foreach ($step in $stepsToRun) {
        Invoke-Step $step
    }

    Write-Host "`nBUILD SUCCEEDED ($Preset)"
}
catch {
    Write-Error "BUILD FAILED: $($_.Exception.Message)"
    exit 1
}