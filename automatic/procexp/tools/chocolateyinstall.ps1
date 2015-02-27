$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage '{{PackageName}}' '{{DownloadUrl}}' $installDir

$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutPath = Join-Path "$programs" "Sysinternals"
$shortcutFilePath = Join-Path $shortcutPath "Process Explorer.lnk"
if(!(Test-Path $shortcutPath)) {
    md $shortcutPath
}

$targetPath = Join-Path $installDir "procexp.exe"
if(Get-Command "Install-ChocolateyShortcut" -ErrorAction SilentlyContinue) { # New, compiled Choco
    Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
}
else { # PowerShell Choco
    $shell = New-Object -comObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutFilePath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
}