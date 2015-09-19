$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'configuration.xml')
Install-ChocolateyPackage 'officeClickToRun' 'exe' "/extract:`"$env:temp\office`" /log:`"$env:temp\officeInstall.log`" /quiet /norestart" '{{DownloadUrl}}'
Install-ChocolateyInstallPackage 'officeClickToRun' 'exe' "/download $configFile" "$env:temp\office\setup.exe"
Install-ChocolateyInstallPackage 'officeClickToRun' 'exe' "/configure $configFile" "$env:temp\office\setup.exe"