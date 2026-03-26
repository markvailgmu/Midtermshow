# Downloads Microsoft Visual Studio Build Tools and installs the C++ / MSVC workload (~2–4 GB).
# Must run as Administrator. Does not commit the installer to git — download is at runtime only.

$ErrorActionPreference = 'Stop'

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host 'Relaunching elevated...'
    Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`""
    ) | Out-Null
    exit 0
}

$bootstrapUrl = 'https://aka.ms/vs/17/release/vs_buildtools.exe'
$dir = $PSScriptRoot
$bootstrap = Join-Path $dir 'vs_buildtools.exe'

Write-Host 'Downloading Visual Studio Build Tools bootstrapper...'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $bootstrapUrl -OutFile $bootstrap -UseBasicParsing

Write-Host 'Installing C++ build tools (MSVC, SDK). This can take a long time.'
$args = @(
    '--quiet', '--wait', '--norestart',
    '--add', 'Microsoft.VisualStudio.Workload.VCTools',
    '--includeRecommended'
)
$p = Start-Process -FilePath $bootstrap -ArgumentList $args -Wait -PassThru -NoNewWindow

if ($p.ExitCode -ne 0 -and $p.ExitCode -ne 3010) {
    Write-Host "Installer exited with code $($p.ExitCode). If failed, try: https://visualstudio.microsoft.com/downloads/"
    exit $p.ExitCode
}

if ($p.ExitCode -eq 3010) {
    Write-Host 'Success (reboot required before using cl.exe).'
} else {
    Write-Host 'Done. Open a new terminal and run .\build.bat in this folder.'
}
exit 0
