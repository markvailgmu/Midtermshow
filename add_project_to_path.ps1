# Run once (PowerShell): adds this folder to your USER Path so you can type mydir / mypwd / mycd_api without .\
# Close and reopen the terminal after running, or use this same window.

$ErrorActionPreference = 'Stop'
$dir = (Resolve-Path $PSScriptRoot).Path

$user = [Environment]::GetEnvironmentVariable('Path', 'User')
$parts = $user -split ';' | Where-Object { $_ -and $_.Trim() -ne '' }
if ($parts -contains $dir) {
    Write-Host "Already on PATH: $dir"
} else {
    [Environment]::SetEnvironmentVariable('Path', ($user.TrimEnd(';') + ';' + $dir), 'User')
    Write-Host "Added to user PATH: $dir"
}

$env:PATH = $dir + ';' + $env:PATH
Write-Host "This session updated. New terminals will also see it. Try: mydir"
