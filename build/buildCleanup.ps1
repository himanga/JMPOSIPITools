#Cleanup
if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force -Confirm:$false $TempPath
}