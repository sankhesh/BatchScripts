rem @ECHO OFF
setlocal enableextensions enabledelayedexpansion

echo %time%
set CURRENT_DIR="%CD%"

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

rem Figure out the drive to install to
call SoftwareDrive.bat
set PERL_DIR=%DRIVETOUSE%:\Software\StrawberryPerl\
set OpenSSL_PATH=%DRIVETOUSE%:\Projects\openssl
set OpenSSL_SRC=%OpenSSL_PATH%\openssl
set OpenSSL_BLD=%OpenSSL_PATH%\bld
set OpenSSL_INSTALL=%OpenSSL_PATH%\install
set OpenSSL_DIR=%OpenSSL_INSTALL%\ssl
for /f "tokens=1* delims=,,," %%i in ('where git') do set GIT_EXE=%%i

set SRC_EXISTED=1
if NOT EXIST %OpenSSL_SRC% (
  CALL "%GIT_EXE%" clone https://github.com/openssl/openssl.git %OpenSSL_SRC%
  set SRC_EXISTED=0
)

set CLEAN_BLD=n
if %SRC_EXISTED% GTR 0 (
  if EXIST %OpenSSL_BLD% (SET /p CLEAN_BLD="%OpenSSL_BLD% exists. Clean build tree?[y/N]: ")
) else (
  set CLEAN_BLD=y
)

if %CLEAN_BLD% EQU y (
  rmdir /Q /S %OpenSSL_BLD%
)
mkdir %OpenSSL_BLD%

cd /D %OpenSSL_SRC%
if %SRC_EXISTED% GTR 0 (
  call "%GIT_EXE%" fetch origin --tags --prune
)

REM Get currently checked out tag
for /f "tokens=1" %%i in ('git describe') do set TAG=%%i
set /p TAG="TAG to build [%TAG%] (Enter 't' to list all tags): "
:while1
  if /I !TAG! EQU t (
    call "%GIT_EXE%" tag -l --sort -version:refname
    for /f "tokens=1"  %%i in ('git describe') do set TAG=%%i
    set /p TAG="TAG to build [!TAG!] (Enter 't' to list all tags): "
    goto :while1
  )
echo "Checking out tag: %TAG%"
call "%GIT_EXE%" checkout %TAG%

rem Configure
cd /D %OpenSSL_BLD%
call %PERL_DIR%\perl\bin\perl %OpenSSL_SRC%\Configure VC-WIN64A --prefix=%OpenSSL_INSTALL% ^
  --openssldir=%OpenSSL_DIR% --debug no-afalgeng no-asm no-capieng

rem Build
nmake

rem Install
nmake install

rem Clean
nmake clean

rem We're done..
cd /D %CURRENT_DIR%
echo %time%
