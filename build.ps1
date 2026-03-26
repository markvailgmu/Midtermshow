$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$bat = Join-Path $PSScriptRoot 'build.bat'
if (-not (Test-Path -LiteralPath $bat)) { throw "Missing build.bat" }
$p = Start-Process -FilePath 'cmd.exe' -ArgumentList @('/c', "`"$bat`"") -Wait -PassThru -NoNewWindow
exit $p.ExitCode
