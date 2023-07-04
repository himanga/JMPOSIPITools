<#
About: This File
Build the add-in.

Section: Globals

This file is part of the JMP OSI PI Tools Add-In.

This Add-In is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This Add-In is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the Add-In. If not, see <https://www.gnu.org/licenses/>.
#>

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

#Copy changelog into add-in directory
Copy-Item -Path "CHANGELOG.md" -Destination $TempPath"CHANGELOG.txt"
Copy-Item -Path "README.md" -Destination $TempPath"README.txt"
Copy-Item -Path "LICENSE" -Destination $TempPath"LICENSE.txt"

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
