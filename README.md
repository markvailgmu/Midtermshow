# Midtermshow

## Commands

- `build.bat` — build the project
- `build.ps1` — build and add this folder to PATH for the current PowerShell window
- `tools.ps1` — add this folder to PATH for the current session
- `add_project_to_path.bat` — add this folder to your user PATH permanently
- `add_project_to_path.ps1` — same as the batch file (PowerShell)
- `install_msvc.bat` — install MSVC (run as administrator)
- `install_msvc.ps1` — same as the batch file (PowerShell)
- `run.cmd` — runs `build.bat`, then pauses
- `mycd.bat` — `cd` to a folder (uses `mypwd.exe` to print the new directory)

After a build, you can run `mydir`, `mypwd`, and `mycd_api` from this directory (or from PATH if you used `build.ps1`, `tools.ps1`, or added the folder to PATH).
