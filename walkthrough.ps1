$sections = @(
    @"
=== 1. PROJECT ===
Three C++ tools: mydir (list), mycd_api (Win32 Set/GetCurrentDirectory), mypwd (print cwd).
Batch mycd.bat uses cd /d + PATH so mycd + mypwd behave like a normal shell.
"@,
    @"
=== 2. APIs — mypwd.cpp ===
GetCurrentDirectoryW — print cwd
GetLastError — on failure
"@,
    @"
=== 2. APIs — mycd.cpp (mycd_api.exe) ===
SetCurrentDirectoryW — argv[1]
GetCurrentDirectoryW — proof line after success
GetLastError — failures
"@,
    @"
=== 2. APIs — mydir.cpp ===
GetCurrentDirectoryW — default path
GetFullPathNameW — Directory of ... header
FindFirstFileW / FindNextFileW / FindClose — enumerate
FileTimeToLocalFileTime / FileTimeToSystemTime — creation time display
GetNamedSecurityInfoW + LookupAccountSidW + LocalFree — /q owner
advapi32.lib — linked for security APIs
"@,
    @"
=== 3. FLAGS (mydir) ===
/a — show hidden + system (FILE_ATTRIBUTE_HIDDEN | SYSTEM)
/s — recurse subdirs
/q — owner column
"@,
    @"
=== 4. COMMANDS ===
Build:  .\build.bat   or   .\build.ps1
Run:    .\mypwd.exe
        .\mydir.exe
        .\mydir.exe /a /s /q .
        .\mycd_api.exe C:\Windows
        mycd  <path>    (uses mycd.bat after PATH setup)
Session PATH:  .\tools.ps1
Permanent PATH:  add_project_to_path.bat
"@,
    @"
=== 5. DETECTION ===
Sysmon EID 1: Image + CommandLine (mydir.exe /a /s/q ...)
Procmon: filter Process Name mydir.exe — CreateFile / directory access
"@
)

foreach ($s in $sections) {
    Write-Host $s -ForegroundColor Cyan
    Write-Host ""
}
Write-Host "Full detail: WALKTHROUGH.md in this folder." -ForegroundColor Yellow
