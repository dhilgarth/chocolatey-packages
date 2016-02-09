$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"

$packageName = '{{PackageName}}' # arbitrary name for the package, used in messages
$installerType = 'EXE'
$url = '{{DownloadUrl}}'
$url64 = '{{DownloadUrlx64}}'
$silentArgs = '/S'
$validExitCodes = @(0) 

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes

$arguments = (ParseParameters $env:chocolateyPackageParameters)

if($arguments.ContainsKey("licenseCode") -and $arguments.ContainsKey("licenseName")) {

    $licenseCode = $arguments["licenseCode"]
    $licenseName = $arguments["licenseName"]

    $registrationFile = Join-Path ([environment]::getfolderpath("mydocuments")) "Room Arranger\regbak.rrg"
    "[Options]" > $registrationFile
    "RegName=$licenseName" >> $registrationFile
    "RegNumber=$licenseCode" >> $registrationFile
}