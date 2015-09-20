$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"

# Refresh environment from registry
Update-SessionEnvironment

$exeGit = Get-FullAppPath "Git version [0-9\.]+(-preview\d*)?" "cmd" "git.exe"

& "$exeGit" config --global --unset gitflow.path.hooks

rm $installDir = Join-Path (Get-BinRoot) "gitflow-hooks"
