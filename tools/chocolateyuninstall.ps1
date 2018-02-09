
$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'setlx'
$softwareName = 'setlx*' 
$toolsDir   = Get-ToolsLocation
$installPath = Join-Path $toolsDir $packageName

$silentArgs = '/qn /norestart'
# https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
 Remove-Item "$toolsDir\$packageName" -Force -Recurse
Uninstall-ChocolateyEnvironmentVariable -VariableName $installPath -VariableType 'Machine'

$uninstalled = $true
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName
