$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\extensions.ps1"
. "$toolsPath\generateMst.ps1"

$arguments = (ParseParameters $env:chocolateyPackageParameters)
$packageName = 'snagit' # arbitrary name for the package, used in messages
$url = 'http://download.techsmith.com/snagit/enu/1241/snagit.msi'
$installerType = 'MSI'
$silentArgs = '/qn'
$validExitCodes = @(0) 

if($arguments.Contains("licenseCode")) {

    $licenseCode = $arguments["licenseCode"]

    $mstReplacements = @(
    )

    $mstAdditions = @(
    [pscustomobject]@{Property="TSC_SOFTWARE_KEY";Value=$licenseCode}
    )

    $chocTempDir = Join-Path (Get-Item $env:TEMP).FullName "chocolatey"
    $tempDir = Join-Path $chocTempDir "$packageName"

    if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }

    $msi = Join-Path $tempDir "snagit.msi"
    $mst = Join-Path $tempDir "snagit.mst"
    $args = "TRANSFORMS=`"$mst`" /qn"

    Get-ChocolateyWebFile $packageName $msi $url
    GenerateMST -MsiPath $msi  -MstPath $mst -Replacements $mstReplacements -Additions $mstAdditions
    Install-ChocolateyInstallPackage "$packageName" "$installerType" $args $msi -validExitCodes $validExitCodes
}
else {
    Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
}