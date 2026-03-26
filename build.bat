@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

REM Always load vcvars64 when possible. If we skip this because "cl" is already on PATH,
REM INCLUDE may be wrong and you get: fatal error C1083: cannot open include file 'windows.h'

call :load_vcvars
where cl >nul 2>&1
if errorlevel 1 (
  echo ERROR: cl.exe not found. Install MSVC / Windows SDK ^(Desktop development with C++^) or run from "x64 Native Tools Command Prompt for VS".
  exit /b 1
)

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
echo ERROR: compile failed. If you see C1083 windows.h: open Visual Studio Installer -^> Modify -^> add "Windows 10/11 SDK" under Individual components.
exit /b 1

:load_vcvars
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
  for /f "usebackq tokens=* delims=" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2^>nul`) do (
    if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" (
      call "%%i\VC\Auxiliary\Build\vcvars64.bat" >nul
      exit /b 0
    )
  )
  for /f "usebackq tokens=* delims=" %%i in (`"%VSWHERE%" -latest -products * -property installationPath 2^>nul`) do (
    if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" (
      call "%%i\VC\Auxiliary\Build\vcvars64.bat" >nul
      exit /b 0
    )
  )
)
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Professional\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\18\Professional\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
  call "%ProgramFiles%\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
  exit /b 0
)
exit /b 0
