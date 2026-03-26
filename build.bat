@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

where cl >nul 2>&1
if not errorlevel 1 goto :compile

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
  for /f "usebackq tokens=* delims=" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2^>nul`) do (
    if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" (
      call "%%i\VC\Auxiliary\Build\vcvars64.bat" >nul
      goto :checkcl
    )
  )
  for /f "usebackq tokens=* delims=" %%i in (`"%VSWHERE%" -latest -products * -property installationPath 2^>nul`) do (
    if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" (
      call "%%i\VC\Auxiliary\Build\vcvars64.bat" >nul
      goto :checkcl
    )
  )
)

if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Professional\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\18\Professional\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)
if exist "%ProgramFiles%\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
  goto :checkcl
)

echo ERROR: Could not find MSVC ^(cl.exe^). Install "Desktop development with C++" or "C++ build tools"
echo from Visual Studio Installer, then run again. Or open "x64 Native Tools Command Prompt for VS"
echo and run:  build.bat
exit /b 1

:checkcl
where cl >nul 2>&1
if errorlevel 1 (
  echo ERROR: vcvars64 ran but cl.exe is still not on PATH.
  exit /b 1
)

:compile
del /f /q mycd.exe 2>nul
echo Compiling...
cl /nologo /EHsc /O2 /W3 /Fe:mydir.exe mydir.cpp
if errorlevel 1 goto :bad
cl /nologo /EHsc /O2 /W3 /Fe:mycd_api.exe mycd.cpp
if errorlevel 1 goto :bad
cl /nologo /EHsc /O2 /W3 /Fe:mypwd.exe mypwd.cpp
if errorlevel 1 goto :bad
echo.
echo OK — Built: mydir.exe  mycd_api.exe  mypwd.exe
exit /b 0

:bad
echo.
echo ERROR: compile failed.
exit /b 1
