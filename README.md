# Midtermshow

## Build

Open **`testmid`** and run **`build.bat`**. It emits the three `.cpp` sources (embedded in the batch file) and builds **mydir.exe**, **mycd_api.exe**, and **mypwd.exe**.

Requires MSVC (`cl`). The batch file tries to run **`vcvars64.bat`** via **vswhere** if `cl` is not already on your PATH.
