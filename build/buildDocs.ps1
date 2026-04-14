& $NaturalDocsExe "NaturalDocs"

$moduleName = "MarkdownToHtml"
if (-not (Get-Module -ListAvailable -Name $moduleName)) {
    Install-Module -Name $moduleName -Scope CurrentUser -Force
}
Import-Module MarkdownToHtml

New-HTMLTemplate -Destination $TempPath
Convert-MarkdownToHtml -Path "README.md"   -Template "MarkdownTemplate/" -SiteDirectory $TempPath
Convert-MarkdownToHtml -Path "CHANGELOG.md" -Template "MarkdownTemplate/" -SiteDirectory $TempPath

Copy-Item "LICENSE" "$TempPath\LICENSE.txt"