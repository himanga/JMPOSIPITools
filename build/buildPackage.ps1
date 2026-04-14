$meta = Get-CustomMetadata (Join-Path $TempPath $CustomMetadataRel)

$FileBase = "JMPOSIPITools_{0}_{1}" -f $meta.Version, $meta.State
$ZipFile  = "$FileBase.zip"
$AddinFile = "$FileBase.jmpaddin"

Remove-Item $ZipFile, $AddinFile -Force -ErrorAction SilentlyContinue

#Compress-Archive -Path "$TempPath\*" -DestinationPath $ZipFile -CompressionLevel Fastest
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    (Resolve-Path $TempPath),
    (Join-Path (Get-Location) $ZipFile),
    [System.IO.Compression.CompressionLevel]::Fastest,
    $false
)
Rename-Item $ZipFile $AddinFile

return $AddinFile