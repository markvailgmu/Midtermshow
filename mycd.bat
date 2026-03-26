@echo off
set "PATH=%~dp0;%PATH%"
if "%~1"=="" exit /b 1
cd /d "%~1"
if errorlevel 1 exit /b 1
echo Current directory is now:
"%~dp0mypwd.exe"
