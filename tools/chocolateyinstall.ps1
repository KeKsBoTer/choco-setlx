# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'setlx' # arbitrary name for the package, used in messages
$toolsDir   = Get-ToolsLocation
$url        = 'http://download.randoom.org/setlX/pc/setlX_v2-7-0.binary_only.zip' # download url, HTTPS preferred
#$url64      = '' # 64bit URL here (HTTPS preferred) or remove - if installer contains both (very rare), use $url
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
#$fileLocation = '\\SHARE_LOCATION\to\INSTALLER_FILE'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = Join-Path $toolsDir $packageName
  url           = $url
  url64bit      = $url64
  #file         = $fileLocation

  softwareName  = 'setlx*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  # Checksums are now required as of 0.10.0.
  # To determine checksums, you can get that from the original site if provided. 
  # You can also use checksum.exe (choco install checksum) and use it 
  # e.g. checksum -t sha256 -f path\to\file
  checksum      = '876C8AAD46FC8C08E71D55FC0E6B9A46D753F16EA9655D1BEAE76D170B1F2DE3'
  checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
  checksum64    = '876C8AAD46FC8C08E71D55FC0E6B9A46D753F16EA9655D1BEAE76D170B1F2DE3'
  checksumType64= 'sha256' #default is checksumType

  #MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyZipPackage @packageArgs

#Rename-Item -Path "$toolsDir\$packageName\setlXlibrary" -NewName "library"

$setlxCmd = "$toolsDir\$packageName\setlX.cmd"

(gc $setlxCmd) -replace "set setlXJarDirectory=.", "set setlXJarDirectory=$toolsDir\$packageName\" | sc $setlxCmd

(gc $setlxCmd) -replace "set SETLX_LIBRARY_PATH=(.*)", "set SETLX_LIBRARY_PATH=$toolsDir\$packageName\setlXlibrary" | sc $setlxCmd

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$toolsDir\$packageName", [EnvironmentVariableTarget]::Machine)

if(!$?)
{
	exit 1
}

setlx --version