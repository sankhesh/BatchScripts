rem @ECHO OFF
echo %time%
set CURRENT_DIR="%CD%"

rem ===============================================================================
rem Script variables setup
rem ===============================================================================

rem Figure out the drive to install to
call SoftwareDrive.bat
set CLINK_DIR=%DRIVETOUSE%:\Software\clink

rem ===============================================================================
rem Script start
rem ===============================================================================

powershell -NoProfile -ExecutionPolicy RemoteSigned -File %0\..\ClinkInstall.ps1 -dst %CLINK_DIR%

rem ===============================================================================
rem Configuration
rem ===============================================================================

rem -------------------------------------------------------------------------------
rem fzf
rem -------------------------------------------------------------------------------
set CLINK_SCRIPTS_DIR=%CLINK_DIR%\scripts\
if NOT EXIST %CLINK_SCRIPTS_DIR% (
  mkdir %CLINK_SCRIPTS_DIR%
)
cd %CLINK_SCRIPTS_DIR%
powershell -NoProfile -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/chrisant996/clink-fzf/main/fzf.lua -O fzf.lua"
cd /D %CURRENT_DIR%

call %CLINK_DIR%\clink_x64.exe set fzf.exe_location %USERPROFILE%\.fzf\bin\fzf.exe

rem -------------------------------------------------------------------------------
rem clink-completions
rem -------------------------------------------------------------------------------
powershell -NoProfile -ExecutionPolicy RemoteSigned -File %0\..\DownloadRelease.ps1 -dst %CLINK_SCRIPTS_DIR% -url "https://api.github.com/repos/vladimir-kotikov/clink-completions/releases/latest"

rem Finally set the scripts path in the clink settings
call %CLINK_DIR%\clink_x64.exe set clink.path %CLINK_SCRIPTS_DIR%

echo %time%
