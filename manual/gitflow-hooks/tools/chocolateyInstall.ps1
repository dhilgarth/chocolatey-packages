$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"

$giturl = "https://github.com/jaspernbrouwer/git-flow-hooks.git"

# Refresh environment from registry
Update-SessionEnvironment

$exeGit = Get-FullAppPath "Git version [0-9\.]+(-preview\d*)?" "cmd" "git.exe"

$installDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$config = Join-Path $installDir "git-flow-hooks-config.sh"

Start-ChocolateyProcessAsAdmin "/c `"`"$exeGit`" clone --recursive `"$giturl`" `"$installDir`"`"" -exe "$env:comspec"
"VERSION_FILE=`"version\version.txt`"" > $config
"VERSION_BUMPLEVEL_HOTFIX=`"PATCH`"" >> $config
"VERSION_BUMPLEVEL_RELEASE=`"MINOR`"" >> $config
& "$exeGit" config --global --add gitflow.path.hooks $installDir
