$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutPath = Join-Path "$programs" "Sysinternals"
$shortcutFilePath = Join-Path $shortcutPath "Process Explorer.lnk"
if((Test-Path $shortcutFilePath)) {
    del $shortcutFilePath
}

if((Get-ChildItem $shortcutPath -force | Select-Object -First 1 | Measure-Object).Count -eq 0) {
   rd $shortcutPath
}