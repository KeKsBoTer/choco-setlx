$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'setlx'
$toolsDir   = Get-ToolsLocation
$url        = 'http://download.randoom.org/setlX/pc/setlX_v2-7-0.binary_only.zip'
$installPath = Join-Path $toolsDir $packageName

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $installPath
  url           = $url
  url64bit      = $url64

  softwareName  = 'setlx*'
  checksum      = '876C8AAD46FC8C08E71D55FC0E6B9A46D753F16EA9655D1BEAE76D170B1F2DE3'
  checksumType  = 'sha256' 
  checksum64    = '876C8AAD46FC8C08E71D55FC0E6B9A46D753F16EA9655D1BEAE76D170B1F2DE3'
  checksumType64= 'sha256'

  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyZipPackage @packageArgs

$setlxCmd = "$toolsDir\$packageName\setlX.cmd"

(gc $setlxCmd) -replace "set setlXJarDirectory=.", "set setlXJarDirectory=$toolsDir\$packageName\" | sc $setlxCmd

(gc $setlxCmd) -replace "set SETLX_LIBRARY_PATH=(.*)", "set SETLX_LIBRARY_PATH=$toolsDir\$packageName\setlXlibrary" | sc $setlxCmd

Install-ChocolateyPath  $installPath -PathType 'Machine'