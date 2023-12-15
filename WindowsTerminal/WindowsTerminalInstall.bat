rem  @ECHO off
setlocal enableextensions enabledelayedexpansion

echo %time%
set CURRENT_DIR="%CD%"

set pack=%LocalAppData%\Packages
set ter=Microsoft.WindowsTerminal_8wekyb3d8bbwe
set defset=%pack%\%ter%
if EXIST %defset% (
  goto link
)

call SoftwareDrive.bat
set dst=%DRIVETOUSE%:\Software\WindowsTerminal\
if NOT EXIST %dst% (
  mkdir %dst%
)

rem Create the GitHub download latest release query url
for /f "delims=" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -File %0\..\..\ps_scripts\create_dl_url.ps1 -repo "microsoft/terminal" ') do set "dlurl=%%a"
set dlurl

rem Download the latest release
start /b /wait powershell -NoProfile -ExecutionPolicy RemoteSigned -File %0\..\..\ps_scripts\DownloadRelease.ps1 -dst %dst% -url %dlurl% -includes "x64"

start /wait %dst%\wt.exe
rem Give time for the process to start
timeout /t 3 /nobreak > nul
:loop
tasklist.exe /fi "imagename eq WindowsTerminal.exe" | find /v "No tasks" > nul && (echo "Default settings created.") || (goto loop)
taskkill /f /im WindowsTerminal.exe

:link
rem Add a symlink for settings
if EXIST %defset% (
  set setFile="%defset%\LocalState\settings.json"
) else (
  set setFile="%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json"
)
del /q %setFile%
mklink %setFile% %~dp0\WindowsTerminalSettings.json

echo "If fonts don't look good, run the InstallCascadiaFonts.bat script!"

cd /D %CURRENT_DIR%
echo %time%
