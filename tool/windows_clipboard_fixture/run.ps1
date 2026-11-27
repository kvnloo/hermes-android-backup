param(
  [Parameter(Mandatory=$true)][string]$BuildRoot,
  [string]$Plugin = 'C:\dev\pub-cache\hosted\pub.dev\pasteboard-0.6.2',
  [string]$VcVars = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat'
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$stage = $PSScriptRoot
$ephemeral = Join-Path $BuildRoot 'windows\flutter\ephemeral'
$wrapper = Join-Path $BuildRoot 'build\windows\x64\flutter\Release\flutter_wrapper_plugin.lib'
$source = Join-Path $Plugin 'windows\pasteboard_plugin.cpp'
# The harness is source-bound to the exact version audited in this regression.
if ((Get-FileHash $source -Algorithm SHA256).Hash -ne 'F71E6253FB0ACFA9DAE9BD0A3C970880AEFBB3E4CC062E1513B37704F3BBBA3B') { throw 'Pinned plugin source mismatch' }
$include = Join-Path $ephemeral 'cpp_client_wrapper\include'
$pluginInclude = Join-Path $Plugin 'windows'
$dllLib = Join-Path $ephemeral 'flutter_windows.dll.lib'
$dll = Join-Path $ephemeral 'flutter_windows.dll'
foreach ($file in @($wrapper,$source,$dllLib,$dll,$VcVars)) {
  if (!(Test-Path $file)) { throw "Missing prerequisite: $file" }
}
Push-Location $stage
try {
  $line = '"' + $VcVars + '" && cl /nologo /std:c++17 /EHsc /MD /DUNICODE /D_UNICODE /DFLUTTER_PLUGIN_IMPL /I"' + $include + '" /I"' + $ephemeral + '" /I"' + $pluginInclude + '" native_reader.cpp /Fe:native_reader.exe /link "' + $wrapper + '" "' + $dllLib + '" user32.lib gdi32.lib shell32.lib ole32.lib'
  & cmd.exe /d /s /c $line
  if ($LASTEXITCODE -ne 0) { throw "Compilation failed: $LASTEXITCODE" }
  Copy-Item $dll (Join-Path $stage 'flutter_windows.dll')
  # This console test never creates a Flutter engine or calls actual clipboard APIs.
  & .\native_reader.exe (Join-Path $stage 'fixtures')
  if ($LASTEXITCODE -ne 0) { throw "Native fixture failed: $LASTEXITCODE" }
  Get-ChildItem (Join-Path $stage 'fixtures') -File | ForEach-Object {
    [pscustomobject]@{Name=$_.Name;Bytes=$_.Length;SHA256=(Get-FileHash $_.FullName -Algorithm SHA256).Hash}
  } | ConvertTo-Json
} finally { Pop-Location }
