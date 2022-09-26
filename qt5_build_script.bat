rem @ECHO OFF
setlocal enableextensions enabledelayedexpansion

echo %time%
set CURRENT_DIR="%CD%"

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

rem Figure out the drive to install to
call SoftwareDrive.bat
set PYTHON_DIR=%DRIVETOUSE%:\Software\Python\
set PERL_DIR=%DRIVETOUSE%:\Software\StrawberryPerl\
set JOM_DIR=%DRIVETOUSE%:\Software\jom\
set QT_PATH=%DRIVETOUSE%:\Projects\Qt
for /f "tokens=1* delims=,,," %%i in ('where git') do set GIT_EXE=%%i

set QT_SRC=%QT_PATH%\qt5
set QT_BLD=%QT_PATH%\bld
set QT_INSTALL=%QT_PATH%\install
set QTDIR=%QT_BLD%\qtbase
rem set QMAKESPEC=win32-msvc2017
set PATH=%QT_BLD%\bin;%QTDIR%\bin;%QT_SRC%\qtrepotools\bin;%QT_SRC%\gnuwin32\bin;%PYTHON_DIR%;"%GIT_PATH%\bin";%PERL_DIR%\perl\bin;%PATH%

set SRC_EXISTED=1
if NOT EXIST %QT_SRC% (
  CALL "%GIT_EXE%" clone git://code.qt.io/qt/qt5.git %QT_SRC%
  set SRC_EXISTED=0
)

rem Include libICU for webkit
rem set INCLUDE=%INCLUDE%;F:\Software\icu4c-54_1-Win64-msvc10\icu\include
rem set LIB=%LIB%;F:\Software\icu4c-54_1-Win64-msvc10\icu\lib64

set CLEAN_BLD=n
if %SRC_EXISTED% GTR 0 (
  if EXIST %QT_BLD% (SET /p CLEAN_BLD="%QT_BLD% exists. Clean build tree?[y/N]: ")
) else (
  set CLEAN_BLD=y
)

if %CLEAN_BLD% EQU y (
  rmdir /Q /S %QT_BLD%
)
mkdir %QT_BLD%

cd /D %QT_SRC%
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

set INIT=n
set FORCE_UPDATE=""
if %SRC_EXISTED% GTR 0 (
  set /p INIT="Initialize Qt submodules?[y/N]: "
  if /I !INIT! EQU Y (
    set FORCE_UPDATE="-f"
    echo "FORCE_UPDATE = !FORCE_UPDATE!"
  )
) else (
  set INIT=y
)

if /I !INIT! EQU Y (
  cd /D %QT_SRC%
  %PERL_DIR%\perl\bin\perl.exe init-repository %FORCE_UPDATE:"=% --module-subset=default,-qt3d,-qtactiveqt,-qtandroidextras,-qtcanvas3d,-qtcharts,-qtconnectivity,-qtdatavis3d,-qtdoc,-qtdocgallery,-qtfeedback,-qtgamepad,-qtgraphicaleffects,-qtlocation,-qtmacextras,-qtnetworkauth,-qtpim,-qtpurchasing,-qtqa,-qtscxml,-qtsensors,-qtserialbus,-qtspeech,-qttranslations,-qtvirtualkeyboard,-qtwayland,-qtx11extras
) else (
  call "%GIT_EXE%" submodule update
)

cd /D %QT_BLD%
call %QT_SRC%\configure -opensource -confirm-license -debug-and-release ^
  -mp -no-icu -opengl desktop^
  -nomake tests -nomake examples ^
  -prefix %QT_INSTALL% ^
  -skip qt3d ^
  -skip qtactiveqt ^
  -skip qtandroidextras ^
  -skip qtcanvas3d ^
  -skip qtcharts ^
  -skip qtconnectivity ^
  -skip qtdatavis3d ^
  -skip qtdoc ^
  -skip qtdocgallery ^
  -skip qtfeedback ^
  -skip qtgamepad ^
  -skip qtgraphicaleffects ^
  -skip qtlocation ^
  -skip qtmacextras ^
  -skip qtpim ^
  -skip qtpurchasing ^
  -skip qtqa ^
  -skip qtscxml ^
  -skip qtsensors ^
  -skip qtserialbus ^
  -skip qtspeech ^
  -skip qttranslations ^
  -skip qtvirtualkeyboard ^
  -skip qtwayland ^
  -skip qtx11extras ^
  -openssl -I %DRIVETOUSE%:\Software\OpenSSL\Debug\include -L %DRIVETOUSE%:\Software\OpenSSL\Debug\lib

set "tagv=%TAG:v=%"
set "TAGV=%tagv:.=%"

if %TAGV:~0,3% LSS 600 (
  set BLDCMD=%JOM_DIR%\jom.exe
) else (
  set BLDCMD=ninja.exe
)

call %BLDCMD%
call %BLDCMD% install

rem nmake
rem nmake qdoc3
rem editbin /STACK:0x200000 bin\qdoc3.exe
rem nmake docs
rem nmake install
rem nmake clean
cd /D %CURRENT_DIR%
echo %time%
