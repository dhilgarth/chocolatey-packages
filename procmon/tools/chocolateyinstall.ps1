$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage 'procmon' 'http://download.sysinternals.com/files/ProcessMonitor.zip' $installDir

$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutPath = Join-Path "$programs" "Sysinternals"
$shortcutFilePath = Join-Path $shortcutPath "Process Monitor.lnk"
if(!(Test-Path $shortcutPath)) {
    md $shortcutPath
}

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath (Join-Path $installDir "procmon.exe")