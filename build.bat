@echo off
setlocal
where cl >nul 2>&1
if errorlevel 1 (
  echo cl not in PATH - open x64 Native Tools Command Prompt for VS
  exit /b 1
)

cl /nologo /EHsc /O2 /W3 /Fe:mydir.exe mydir.cpp
if errorlevel 1 exit /b 1
cl /nologo /EHsc /O2 /W3 /Fe:mycd.exe mycd.cpp
if errorlevel 1 exit /b 1
cl /nologo /EHsc /O2 /W3 /Fe:mypwd.exe mypwd.cpp
if errorlevel 1 exit /b 1
echo Built: mydir.exe mycd.exe mypwd.exe
exit /b 0
