rem @ECHO OFF
setlocal enableextensions enabledelayedexpansion

echo %time%
set CURRENT_DIR="%CD%"

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

rem ===============================================================================
rem Script variables setup
rem ===============================================================================

rem Figure out the drive to install to
call SoftwareDrive.bat
set VIM_PATH=%DRIVETOUSE%:\Projects\vim
set VIM_SRC=%VIM_PATH%\vim
set VIM_INSTALL=%VIM_PATH%\install
set VIM_VER=82

set PYTHON_DIR=%DRIVETOUSE%:\Software\Python
set PYTHON_VER=310

set PERL_DIR=%DRIVETOUSE%:\Software\StrawberryPerl\perl
set PERL_VER=528

rem Get gettext and iconv DLLs from the following site:
rem     https://github.com/mlocati/gettext-iconv-windows/releases
rem Both 64- and 32-bit versions are needed.
set GETTEXT32_DIR=%VIM_PATH%\gettext0.21-iconv1.16-shared-32
set GETTEXT64_DIR=%VIM_PATH%\gettext0.21-iconv1.16-shared-64

rem ===============================================================================
rem Script start
rem ===============================================================================

for /f "tokens=1* delims=,,," %%i in ('where git') do set GIT_EXE=%%i

set SRC_EXISTED=1
if NOT EXIST %VIM_SRC% (
  call %GIT_EXE% clone git@github.com:vim/vim.git %VIM_SRC% || exit /b 1
  set SRC_EXISTED=0
)

cd /D %VIM_SRC%

if %SRC_EXISTED% GTR 0 (
  call "%GIT_EXE%" fetch origin --tags --prune
  call "%GIT_EXE%" pull
)

cd /D %VIM_SRC%\src

rem Build GUI version
nmake /f Make_mvc.mak^
  PYTHON3=%PYTHON_DIR%^
  DYNAMIC_PYTHON3=yes^
  PYTHON3_VER=%PYTHON_VER%^
  DYNAMIC_PYTHON3_DLL=python%PYTHON_VER%.dll^
  PERL=%PERL_DIR%^
  DYNAMIC_PERL=yes^
  DIRECTX=yes^
  GUI=yes^
  OLE=yes^
  FEATURES=HUGE^
  VIMDLL=no^
  SOUND=yes^
  TERMINAL=yes^
  CHANNEL=yes^
  MBYTE=yes^
  ICONV=yes^
  DEBUG=no^
  CPUNR=any^
  || exit /b 1

rem Build CUI version
nmake /f Make_mvc.mak^
  PYTHON3=%PYTHON_DIR%^
  DYNAMIC_PYTHON3=yes^
  PYTHON3_VER=%PYTHON_VER%^
  DYNAMIC_PYTHON3_DLL=python%PYTHON_VER%.dll^
  PERL=%PERL_DIR%^
  DYNAMIC_PERL=yes^
  DIRECTX=no^
  GUI=no^
  OLE=no^
  FEATURES=HUGE^
  VIMDLL=no^
  TERMINAL=yes^
  MBYTE=yes^
  ICONV=yes^
  DEBUG=no^
  CPUNR=any^
  || exit /b 1

rem Install the runtime
set DST=%VIM_INSTALL%\vim%VIM_VER%

set UNINSTALL=n
if EXIST %DST% (
  SET /p UNINSTALL="%DST% exists. Uninstall before installing?[y/N]: "
)
if %UNINSTALL% EQU y (
  rem Uninstalling vim
  call %DST%\uninstall
  rmdir /Q /S %DST%
)
mkdir %DST%

xcopy %VIM_SRC%\runtime %DST% /D /E /H /I /Y %*
xcopy %VIM_SRC%\src\xxd\xxd.exe %DST%\* /D /Y %*
xcopy %VIM_SRC%\src\tee\tee.exe %DST%\* /D /Y %*
xcopy %VIM_SRC%\src\GvimExt\gvimext.dll %DST%\* /D /Y %*
xcopy %VIM_SRC%\src\*.exe %DST%\* /D /Y %*

rem Install for windows integration
mkdir %DST%\GvimExt64
xcopy %VIM_SRC%\src\GvimExt\gvimext.dll %DST%\GvimExt64\* /D /Y %*
mkdir %DST%\GvimExt32
xcopy %VIM_SRC%\src\GvimExt\gvimext.dll %DST%\GvimExt32\* /D /Y %*
xcopy %GETTEXT64_DIR%\bin\libintl-*.dll %DST%\* /D /Y %*
xcopy %GETTEXT64_DIR%\bin\libiconv-*.dll %DST%\* /D /Y %*
xcopy %GETTEXT32_DIR%\bin\libgcc_s_sjlj-*.dll %DST%\* /D /Y %*
xcopy %GETTEXT32_DIR%\bin\libintl-*.dll %DST%\GvimExt32\* /D /Y %*
xcopy %GETTEXT32_DIR%\bin\libiconv-*.dll %DST%\GvimExt32\* /D /Y %*
xcopy %GETTEXT32_DIR%\bin\libgcc_s_sjlj-*.dll %DST%\GvimExt32\* /D /Y %*
xcopy %GETTEXT64_DIR%\bin\libintl-*.dll %DST%\GvimExt64\* /D /Y %*
xcopy %GETTEXT64_DIR%\bin\libiconv-*.dll %DST%\GvimExt64\* /D /Y %*

rem Finally, install
REM  Use ConEmu's elevation feature to run the install script as an administrator
REM  If this fails (no ConEmu), comment out the following line and uncomment the line after the
REM  following one.
call cmd.exe /k "%ConEmuBaseDir%\CmdInit.cmd & %DST%\install.exe" -new_console:a
REM  call %DST%\install

cd /D %VIM_SRC%\src
nmake /f Make_mvc.mak clean

cd /D %CURRENT_DIR%
echo %time%
