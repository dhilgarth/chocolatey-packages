$packageName = '{{PackageName}}' # arbitrary name for the package, used in messages
$installerType = 'EXE'
$url = '{{DownloadUrl}}'
$silentArgs = '/quiet /autodelete'
$validExitCodes = @(0) 

$packageParameters = $env:chocolateyPackageParameters;

$languageMap = @{ "zh-CN" = "0804"; "zh-TW" = "0404"; "cs" = "0405"; "da" = "0406"; "nl" = "0413"; "en" = "0409"; "fr" = "040c"; "de" = "0407"; "it" = "0410"; "ja" = "0411"; "pl" = "0415"; "pt" = "0416"; "ru" = "0419"; "sk" = "041b"; "es" = "0c0a"; "sv" = "041d"; }

$arguments = @{};

if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):([`"'])?(?<value>([a-zA-Z0-9- _\\:\.]+))([`"'])?|\/(?<option>([a-zA-Z]+))"  
    #"
    $optionName = 'option'
    $valueName = 'value'
    
    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
          $arguments.Add(
              $_.Groups[$optionName].Value.Trim(),
              $_.Groups[$valueName].Value.Trim())
      }
    }
    else
    {
      throw "Package Parameters were found but were invalid (REGEX Failure)"
    }
}

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$packageName"
$extractDir = Join-Path $tempDir "pdffactorypro-workstation"

if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
$file = Join-Path $tempDir "$($packageName)Install.exe"

Get-ChocolateyWebFile $packageName $file $url
Get-ChocolateyUnzip -fileFullPath $file -destination $extractDir

$setup = Join-Path $extractDir "setup.exe"
if($arguments.ContainsKey("lang")) {
    $lang = $arguments["lang"]
    if(!$languageMap.ContainsKey($lang)) { throw "Unknown language '$lang' specified. The following languages are available:`n" + [system]::string.Join("`n", $languageMap.Keys) }
    $silentArgs = $silentArgs + " /lang=" + $languageMap[$lang]
}

if($arguments.ContainsKey("license")) {
    $iniFile = Join-Path $extractDir "fpp5.ini"
    $licenseCode = $arguments["license"]
    $name = ""
    if($arguments.ContainsKey("name")) { $name = $arguments["name"] }
    $iniFileContents =
@"
[Settings]
Name=$name
SerialNumber=$licenseCode
"@
    $iniFileContents > $iniFile
}

Install-ChocolateyInstallPackage $packageName $installerType $silentArgs $setup -validExitCodes $validExitCodes

rm $tempDir -Recurse