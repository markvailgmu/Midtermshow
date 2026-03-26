@echo off
setlocal
where cl >nul 2>&1
if not errorlevel 1 goto :build
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
  for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
    if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" (
      call "%%i\VC\Auxiliary\Build\vcvars64.bat" >nul
      goto :have_vc
    )
  )
)
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul & goto :have_vc
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" call "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" >nul & goto :have_vc
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" call "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" >nul & goto :have_vc
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" call "%ProgramFiles%\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul & goto :have_vc
if exist "%ProgramFiles%\Microsoft Visual Studio\18\Professional\VC\Auxiliary\Build\vcvars64.bat" call "%ProgramFiles%\Microsoft Visual Studio\18\Professional\VC\Auxiliary\Build\vcvars64.bat" >nul & goto :have_vc
exit /b 1
:have_vc
where cl >nul 2>&1
if errorlevel 1 exit /b 1
:build
cd /d "%~dp0"
del /f /q mycd.exe 2>nul
cl /nologo /EHsc /O2 /W3 /Fe:mydir.exe mydir.cpp
if errorlevel 1 exit /b 1
cl /nologo /EHsc /O2 /W3 /Fe:mycd_api.exe mycd.cpp
if errorlevel 1 exit /b 1
cl /nologo /EHsc /O2 /W3 /Fe:mypwd.exe mypwd.cpp
if errorlevel 1 exit /b 1
exit /b 0
