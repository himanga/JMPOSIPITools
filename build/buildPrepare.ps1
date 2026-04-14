if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force $TempPath
}
New-Item -ItemType Directory -Path $TempPath | Out-Null

Copy-Item -Recurse "$AddinSource\*" $TempPath

$metaPath = Join-Path $TempPath $CustomMetadataRel
$stamp = Get-TimestampForJMP

(Get-Content $metaPath) `
    -replace 'List\( "buildDate", (\d+) \),', "List( `"buildDate`", $stamp )," |
    Set-Content $metaPath