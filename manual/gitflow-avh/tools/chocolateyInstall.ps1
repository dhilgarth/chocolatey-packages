$giturl = "https://github.com/petervanderdoes/gitflow.git"

# Refresh environment from registry
Update-SessionEnvironment

# Detect Git
$apps = @(Show-AppUninstallInfo -match "Git version [0-9\.]+(-preview\d*)?")

if ($apps.Length -eq 0)
{
    throw "Could not detect a valid Git installation"
}

$app = $apps[0]
$gitDir = $app["InstallLocation"]

if (-not (Test-Path "$gitDir"))
{
    throw "Local Git installation is detected, but directories are not accessible or have been removed"
}

# Now clone the repository. Git executable could not be in PATH
# so we are using absolute filenames. Everything must be executed
# with elevated privileges
#
$gitflowDir = Join-Path "$gitDir" "gitflow"
$exeGit = Join-Path "$gitDir" "cmd\git.exe"
$exeInstallGitFlow = Join-Path "$gitflowDir" "contrib\msysgit-install.cmd"
$gitBin = Join-Path "$gitDir" "usr"
$gitBin64 = Join-Path "$gitDir" "mingw64"

if (-not (Test-Path $gitBin))
{
    $gitBin = Join-Path "$gitDir" "mingw"
}

if (Test-Path $(Join-Path "$gitDir" "git-flow"))
{
    Write-Host "`nFound existing Git-Flow. Removing...`n"  -foregroundcolor yellow
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -path '$gitDir' -include 'git-flow*','gitflow-*','gitflow*' -recurse -force | Remove-Item -recurse -force" -minimized
}

Write-Host "`nGit-Flow: Cloning repository from GitHub and installing Git-Flow ...`n"  -foregroundcolor yellow

Start-ChocolateyProcessAsAdmin "/c `"`"$exeGit`" clone --recursive `"$giturl`" `"$gitflowDir`"`"" -exe "$env:comspec" -minimized
Start-ChocolateyProcessAsAdmin "/c `"`"$exeInstallGitFlow`" `"$gitBin`"`"" -exe "$env:comspec" -minimized
if (Test-Path $gitBin64)
{
    Start-ChocolateyProcessAsAdmin "/c `"`"$exeInstallGitFlow`" `"$gitBin64`"`"" -exe "$env:comspec" -minimized
}

Write-Host "`nGit-Flow: Setting up bash completion...`n"  -foregroundcolor yellow
wget https://raw.githubusercontent.com/petervanderdoes/git-flow-completion/develop/git-flow-completion.bash -OutFile (Join-Path "$gitDir" "etc\profile.d\git-flow-completion.sh")