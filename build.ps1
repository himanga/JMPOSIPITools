#Config
#  Set output file name
$FilePathPrefix = "JMPOSIPITools"

#Run Unit Tests


#NaturalDocs
& "C:\Program Files (x86)\Natural Docs\NaturalDocs.exe" "NaturalDocs"


#Save temporary copy of files
$TempPath = "AddinFilesTempForBuild/"

if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force -Confirm:$false $TempPath
}
New-Item -Path $TempPath -ItemType Directory

Copy-Item -Recurse -Path "AddinFiles\*" -Destination $TempPath

#Update temporary copy of files
$updatetime = Get-Date ((Get-Date).ToUniversalTime()) -UFormat %s
$updatetime = [math]::Round($updatetime) + 2082823200
$customMetadataPath = $TempPath+"customMetadata.jsl"
(Get-Content $customMetadataPath) `
    -replace 'List\( \"buildDate\", (\d+) \),', ('List( "buildDate", '+$updatetime+' ),') |
  Out-File $customMetadataPath
$content = Get-Content -path $customMetadataPath

#Make add-in file
$ZipFileName = $FilePathPrefix+".zip"
$AddinFileName = $FilePathPrefix+".jmpaddin"
if (Test-Path $ZipFileName) {
    Remove-Item -Recurse -Force -Confirm:$false  $ZipFileName
}
if (Test-Path $AddinFileName) {
    Remove-Item -Recurse -Force -Confirm:$false  $AddinFileName
}
$compress = @{
    Path = $TempPath+"\*"
    CompressionLevel = "Fastest"
    DestinationPath = $ZipFileName
}
Compress-Archive @compress
Rename-Item -Path $ZipFileName -NewName $AddinFileName

#Cleanup
if (Test-Path $TempPath) {
    Remove-Item -Recurse -Force -Confirm:$false $TempPath
}
