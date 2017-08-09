@ECHO OFF

echo %time%
set CURRENT_DIR="%CD%"

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

set PYTHON_DIR=D:\Software\Python27\
set PERL_DIR=D:\Software\StrawberryPerl\
set JOM_DIR=D:\Software\jom\
set QT_PATH=D:\Projects\Qt
set GIT_PATH="%PROGRAMFILES%\Git"
set GIT_EXE=%GIT_PATH%\bin\git.exe

set QT_SRC=%QT_PATH%\qt5
set QT_BLD=%QT_PATH%\bld
set QT_INSTALL=%QT_PATH%\install
set QTDIR=%QT_BLD%\qtbase
set QMAKESPEC=win32-msvc2015
set PATH=%QT_BLD%\bin;%QTDIR%\bin;%QT_SRC%\qtrepotools\bin;%QT_SRC%\gnuwin32\bin;%PYTHON_DIR%;"%GIT_PATH%\bin";%PERL_DIR%\perl\bin;%PATH%

set SRC_EXISTED=1
if NOT EXIST %QT_SRC% (
	CALL %GIT_EXE% clone git://code.qt.io/qt/qt5.git %QT_SRC%
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
REM Get currently checked out tag
for /f "tokens=1" %%i in ('git describe') do set TAG=%%i
if %SRC_EXISTED% GTR 0 (
  call %GIT_EXE% fetch origin --tags --prune
)
set /p TAG="TAG to build [%TAG%]: "
call %GIT_EXE% checkout %TAG%

set INIT=n
set FORCE_UPDATE=""
if %SRC_EXISTED% GTR 0 (
  set /p INIT="Initialize Qt submodules?[y/N]: "
  if %INIT% EQU y (
    set FORCE_UPDATE="-f"
  )
) else (
  set INIT=y
)

if %INIT% EQU y (
  cd /D %QT_SRC%
  %PERL_DIR%\perl\bin\perl.exe init-repository %FORCE_UPDATE:"=% --module-subset=default,-qt3d,-qtactiveqt,-qtandroidextras,-qtcanvas3d,-qtcharts,-qtconnectivity,-qtdoc,-qtdocgallery,-qtfeedback,-qtlocation,-qtmacextras,-qtpim,-qtqa,-qtscript,-qtsensors,-qttranslations,-qtwebengine,-qtwebkit,-qtx11extras,-qtcharts,-qtcharts,-qtwayland,-qtserialbus,-qtscxml,-qtnetworkauth,-qtdatavis3d,-qtgamepad,-qtpurchasing,-qtwebchannel,-qtserialport,-qtspeech,-qtgraphicaleffects,-qtvirtualkeyboard,-qtmultimedia,-qtimageformats
) else (
  call %GIT_EXE% submodule update
)

cd /D %QT_BLD%
call %QT_SRC%\configure -opensource -confirm-license -release ^
    -mp -platform win32-msvc2017 -no-icu -opengl desktop -verbose^
	-nomake tests -nomake examples ^
	-prefix %QT_INSTALL% ^
	-skip qt3d ^
	-skip qtactiveqt ^
	-skip qtandroidextras ^
	-skip qtcanvas3d ^
	-skip qtcharts ^
	-skip qtconnectivity ^
	-skip qtdoc ^
	-skip qtdocgallery ^
	-skip qtfeedback ^
	-skip qtlocation ^
	-skip qtmacextras ^
	-skip qtpim ^
	-skip qtqa ^
	-skip qtscript ^
	-skip qtsensors ^
	-skip qttranslations ^
	-skip qtwebengine ^
	-skip qtwebkit ^
	-skip qtx11extras ^
	-skip qtcharts ^
	-skip qtwayland ^
	-skip qtserialbus ^
	-skip qtserialport ^
	-skip qtscxml ^
	-skip qtdatavis3d ^
	-skip qtgamepad ^
	-skip qtpurchasing ^
	-skip qtwebchannel ^
	-skip qtspeech ^
	-skip qtgraphicaleffects ^
	-skip qtvirtualkeyboard ^
	-skip qtmultimedia ^
	-skip qtimageformats

call %JOM_DIR%\jom.exe
call %JOM_DIR%\jom.exe install

rem nmake
rem nmake qdoc3
rem editbin /STACK:0x200000 bin\qdoc3.exe
rem nmake docs
rem nmake install
rem nmake clean
cd /D %CURRENT_DIR%
echo %time%
