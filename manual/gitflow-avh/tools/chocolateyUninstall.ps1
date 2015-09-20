$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"

# Refresh environment from registry
Update-SessionEnvironment

$exeGit = Get-FullAppPath "Git version [0-9\.]+(-preview\d*)?" "cmd" "git.exe"

if ($exeGit -ne $null)
{
    $gitDir = (Get-Item $exeGit).Directory.Parent.FullName

    Write-Host "`nUninstalling Git-Flow from detected Git location: $gitDir`n" -foregroundcolor yellow

    # By analyzing msysgit-install.cmd from Git-Flow, I found out exactly
    # what is new in Git folder:
    #   Git\bin: git-flow, git-flow*, gitflow-*, gitflow-shFlags
    #   Git\gitflow: the whole directory from GitHub
    #
    # They are deleting it with removing recursively
    # Git\git-flow* and Git\gitflow-*, so I will do the same.
    #
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -path '$gitDir' -include 'git-flow*','gitflow-*','gitflow*' -recurse -force | Remove-Item -recurse -force" -minimized
}
