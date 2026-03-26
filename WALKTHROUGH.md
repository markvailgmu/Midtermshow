# Project walkthrough — APIs, files, commands

## What this repo is

Three small **C++** programs that use the **Win32 API** directly (no `cmd.exe` / `dir` / `cd` built-ins):

| Output | Source | Role |
|--------|--------|------|
| `mydir.exe` | `mydir.cpp` | List directories/files (`dir`-like) |
| `mycd_api.exe` | `mycd.cpp` | Change directory in **this process** and print proof (`GetCurrentDirectory`) |
| `mypwd.exe` | `mypwd.cpp` | Print current directory |
| `mycd.bat` | (batch) | For **cmd/PowerShell**: `cd /d` + `PATH` so **`mycd`** matches **`mypwd`** after changing folders |

---

## Win32 APIs (by program)

### `mypwd.exe` — `mypwd.cpp`

| API | Purpose |
|-----|---------|
| `GetCurrentDirectoryW` | Read the process current directory into a wide-char buffer |
| `GetLastError` | Error code if the call fails |

### `mycd_api.exe` — `mycd.cpp`

| API | Purpose |
|-----|---------|
| `SetCurrentDirectoryW` | Set the process current directory to `argv[1]` |
| `GetCurrentDirectoryW` | Read it back and print (assignment “proof”) |
| `GetLastError` | On failure of either call |

### `mydir.exe` — `mydir.cpp`

| API | Purpose |
|-----|---------|
| `GetCurrentDirectoryW` | Default target path if none given on command line |
| `GetFullPathNameW` | Canonical path for the `Directory of ...` header |
| `FindFirstFileW` / `FindNextFileW` / `FindClose` | Enumerate `path\*` |
| `FileTimeToLocalFileTime` / `FileTimeToSystemTime` | Show **creation** time (`ftCreationTime`) |
| `GetNamedSecurityInfoW` | Owner SID for **`/q`** (`OWNER_SECURITY_INFORMATION`) |
| `LookupAccountSidW` | SID → `DOMAIN\user` string |
| `LocalFree` | Free security descriptor buffer from `GetNamedSecurityInfoW` |
| `GetLastError` | Various failures |

**Libraries:** `kernel32`, `advapi32` (via `#pragma comment(lib, "advapi32.lib")` for owner lookup).

**Flags (parsed in C, not separate APIs):**

- **`/a`** — include entries with `FILE_ATTRIBUTE_HIDDEN` or `FILE_ATTRIBUTE_SYSTEM` (otherwise skip).
- **`/s`** — recurse into subdirectories (depth-first; subdir list uses `malloc` / `free`).
- **`/q`** — call owner APIs for each file path.

---

## Commands you typically run

### Build (MSVC required)

```text
.\build.bat
```

or in PowerShell (also fixes PATH for that window):

```text
.\build.ps1
```

`build.bat` runs **`vcvars64.bat`** when needed so **`cl.exe`** sees **Windows SDK** (`windows.h`).

### Run tools

PowerShell: either **`.\mydir`**, or run **`.\tools.ps1`** / **`.\build.ps1`** first so **`mydir`** works without `.\`, or use **`add_project_to_path.bat`** once.

```text
.\mypwd.exe
.\mydir.exe
.\mydir.exe /a /s /q .
.\mycd_api.exe C:\Windows
mycd C:\some\path
```

`mycd` (batch) changes **your shell’s** directory; `mycd_api.exe` only changes **its own** process (demo for the rubric).

---

## Detection (Sysmon / Procmon angle)

- **Process Create:** image path + command line show `mydir.exe`, flags, paths.
- **File:** directory enumeration shows up as **`CreateFile`** / directory query patterns in **Procmon** for `mydir.exe`.

---

## File map

```text
mydir.cpp / mycd.cpp / mypwd.cpp  — source
build.bat / build.ps1             — compile
mycd.bat                          — shell-friendly cd
tools.ps1                         — PATH for current PS session
add_project_to_path.ps1           — add folder to user PATH (optional)
install_msvc.ps1                  — install Build Tools + SDK (optional)
```
