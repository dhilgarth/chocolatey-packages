$packageName = '{{PackageName}}' # arbitrary name for the package, used in messages
$installerType = 'MSI'
$url = '{{DownloadUrl}}'
$silentArgs = '/quiet'
$validExitCodes = @(0) 

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes