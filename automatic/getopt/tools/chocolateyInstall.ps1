﻿$binUrl = 'http://sourceforge.net/projects/gnuwin32/files/util-linux/{{PackageVersion}}/util-linux-ng-{{PackageVersion}}-bin.zip/download'
$depUrl = 'http://sourceforge.net/projects/gnuwin32/files/util-linux/{{PackageVersion}}/util-linux-ng-{{PackageVersion}}-dep.zip/download'

$installDir = Join-Path (Get-BinRoot) "getopt"
$downloadDir = Join-Path $env:TEMP "chocolatey\getopt"
if (-not (Test-Path $installDir))
{
    md $installDir
}
if (-not (Test-Path $downloadDir))
{
    md $downloadDir
}

$downloadedBinPackage = Join-Path $downloadDir "bin.zip"
$downloadedDepPackage = Join-Path $downloadDir "dep.zip"

Get-ChocolateyWebFile "$packageName" $downloadedBinPackage $binUrl
Get-ChocolateyWebFile "$packageName" $downloadedDepPackage $depUrl

Get-ChocolateyUnzip $downloadedBinPackage $downloadDir
Get-ChocolateyUnzip $downloadedDepPackage $downloadDir

mv (Join-Path $downloadDir "bin\getopt.exe") (Join-Path $installDir "getopt.exe")
mv (Join-Path $downloadDir "bin\libintl3.dll") (Join-Path $installDir "libintl3.dll")
mv (Join-Path $downloadDir "bin\libiconv2.dll") (Join-Path $installDir "libiconv2.dll")

Install-ChocolateyPath $installDir 'Machine'

rm $downloadDir -recurse