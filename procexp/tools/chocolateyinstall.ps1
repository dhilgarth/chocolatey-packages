$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage 'procexp' 'http://download.sysinternals.com/files/ProcessExplorer.zip' $installDir

$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutPath = Join-Path "$programs" "Sysinternals"
$shortcutFilePath = Join-Path $shortcutPath "Process Explorer.lnk"
if(!(Test-Path $shortcutPath)) {
    md $shortcutPath
}

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath (Join-Path $installDir "procexp.exe")