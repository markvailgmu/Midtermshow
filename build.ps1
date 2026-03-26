$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$bat = Join-Path $root 'build.bat'
if (-not (Test-Path -LiteralPath $bat)) { throw 'Missing build.bat' }
$p = Start-Process -FilePath "$env:ComSpec" -ArgumentList @('/c', 'call', 'build.bat') -WorkingDirectory $root -Wait -PassThru -NoNewWindow
if ($p.ExitCode -eq 0) {
    $env:PATH = "$root;$env:PATH"
    Write-Host ""
    Write-Host "This folder is now on PATH for this PowerShell window only. You can type: mydir   mypwd   mycd"
}
exit $p.ExitCode
