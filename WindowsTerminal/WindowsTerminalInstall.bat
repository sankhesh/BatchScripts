@ECHO off
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

start /wait %dst%\wt.exe|rem
:loop
tasklist /fi "imagename eq WindowsTerminal.exe" > nul
if errorlevel 1 goto loop
taskkill /f /im WindowsTerminal.exe
rem Add a symlink for settings
set setFile="%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json"
del /q %setFile%
mklink %setFile% %~dp0\WindowsTerminalSettings.json
