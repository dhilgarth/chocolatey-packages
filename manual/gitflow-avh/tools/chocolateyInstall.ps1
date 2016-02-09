$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"

$giturl = "https://github.com/petervanderdoes/gitflow.git"

# Refresh environment from registry
Update-SessionEnvironment

$exeGit = Get-FullAppPath "Git version [0-9\.]+(-preview\d*)?" "cmd" "git.exe"

# Now clone the repository. Git executable could not be in PATH
# so we are using absolute filenames. Everything must be executed
# with elevated privileges
#
$gitDir = (Get-Item $exeGit).Directory.Parent.FullName
$gitflowDir = Join-Path "$gitDir" "gitflow"
$exeInstallGitFlow = Join-Path "$gitflowDir" "contrib\msysgit-install.cmd"
$gitBin = Join-Path "$gitDir" "usr"
$gitBin64 = Join-Path "$gitDir" "mingw64"

if (-not (Test-Path $gitBin))
{
    $gitBin = Join-Path "$gitDir" "mingw"
}

Write-Host "`nRemoving existing Git-Flow, if any...`n"  -foregroundcolor yellow
Get-ChildItem -path $gitDir -include 'git-flow*','gitflow-*','gitflow*' -recurse -force | Remove-Item -recurse -force

Write-Host "`nGit-Flow: Cloning repository from GitHub and installing Git-Flow ...`n"  -foregroundcolor yellow

Start-ChocolateyProcessAsAdmin "/c `"`"$exeGit`" clone --recursive `"$giturl`" `"$gitflowDir`"`"" -exe "$env:comspec"
& "$exeInstallGitFlow" "$gitBin"
if (Test-Path $gitBin64)
{
    & "$exeInstallGitFlow" "$gitBin64"
}

Write-Host "`nGit-Flow: Setting up bash completion...`n"  -foregroundcolor yellow
Invoke-WebRequest https://raw.githubusercontent.com/petervanderdoes/git-flow-completion/develop/git-flow-completion.bash -OutFile (Join-Path "$gitDir" "etc\profile.d\git-flow-completion.sh")