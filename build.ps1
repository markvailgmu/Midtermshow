$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$bat = Join-Path $root 'build.bat'
if (-not (Test-Path -LiteralPath $bat)) { throw 'Missing build.bat' }
$p = Start-Process -FilePath "$env:ComSpec" -ArgumentList @('/c', 'call', 'build.bat') -WorkingDirectory $root -Wait -PassThru -NoNewWindow
exit $p.ExitCode
