$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"

$giturl = "https://github.com/jaspernbrouwer/git-flow-hooks.git"

# Refresh environment from registry
Update-SessionEnvironment

$exeGit = Get-FullAppPath "Git version [0-9\.]+(-preview\d*)?" "cmd" "git.exe"

$installDir = Join-Path (Split-Path -parent $toolsPath) "repository"

if((Test-Path $installDir) -and (Test-Path (Join-Path $installDir ".git"))) {
    cd $installDir
    & "$exeGit" fetch --all --tags
}
else {
    & "$exeGit" clone --recursive "$giturl" "$installDir" 2>&1 | write-host
    cd $installDir
}
& "$exeGit" checkout tags/v{{PackageVersion}} 2>&1 | write-host

$arguments = (ParseParameters $env:chocolateyPackageParameters)
if($arguments.ContainsKey("global")) {
    & "$exeGit" config --global --replace gitflow.path.hooks $installDir
}
