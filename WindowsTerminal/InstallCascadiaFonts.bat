REM  @ECHO off

REM Create the GitHub download latest release query url
for /f "delims=" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -File %0\..\..\ps_scripts\create_dl_url.ps1 -repo "microsoft/cascadia-code" ') do set "dlurl=%%a"
set dlurl

set dst=%USERPROFILE%\Downloads\CascadiaCode\
if NOT EXIST %dst% (
  mkdir %dst%
)

rem Download the latest release
start /b /wait powershell -NoProfile -ExecutionPolicy RemoteSigned -File %0\..\..\ps_scripts\DownloadRelease.ps1 -url %dlurl% -includes "CascadiaCode" -dst %dst%

rem Install the fonts
start /b /wait powershell -NoProfile -ExecutionPolicy RemoteSigned -File %0\..\..\ps_scripts\InstallFonts.ps1 -src %dst%\ttf\

rem rmdir /q /s %dst%
