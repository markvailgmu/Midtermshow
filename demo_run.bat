@echo off
cd /d "%~dp0"
title midterm demo - mypwd mydir mycd
color 0A
echo.
echo ########## mypwd ##########
mypwd.exe
echo.
pause

echo ########## mydir (no flags) ##########
mydir.exe
echo.
pause

echo ########## mydir /a ##########
mydir.exe /a .
echo.
pause

echo ########## mydir /q ##########
mydir.exe /q .
echo.
pause

echo ########## mydir /s (recursive) ##########
mydir.exe /s .
echo.
pause

echo ########## mycd C:\Windows ##########
mycd.exe C:\Windows
echo.
pause

echo ########## mycd .. (from this folder) ##########
cd /d "%~dp0"
mycd.exe ..
echo.
pause

echo ########## mycd bad path (expect error) ##########
mycd.exe Z:\folder_that_does_not_exist_xyz
echo.
pause

echo ########## mycd no args (expect usage) ##########
mycd.exe
echo.
echo Done. Close this window or press a key.
pause >nul
