@ECHO OFF

echo %time%
set CURRENT_DIR="%CD%"

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

set PYTHON_DIR=D:\Software\Python2.7.11\
set PERL_DIR=D:\Software\StrawberryPerl5.22.1.2\
set JOM_DIR=D:\Software\jom_1_1_0\
set QT_PATH=D:\Projects\Qt
set GIT_PATH="%PROGRAMFILES%\Git"

set QT_SRC=%QT_PATH%\src
set QT_BLD=%QT_PATH%\bld
set QTDIR=%QT_BLD%\qtbase
set QMAKESPEC=win32-msvc2015
set PATH=%QT_BLD%\bin;%QT_SRC%\qtrepotools\bin;%QT_SRC%\gnuwin32\bin;%PYTHON_DIR%;"%GIT_PATH%\bin";%PATH%

set SRC_EXISTED=1
if NOT EXIST %QT_SRC% (
	CALL %GIT_PATH%\bin\git.exe clone git://code.qt.io/qt/qt5.git %QT_SRC%
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
	mkdir %QT_BLD%
)

set INIT=n
if %SRC_EXISTED% GTR 0 (
	set /p INIT="Initialize Qt submodules?[y/N]: "
) else (
	set INIT=y
)
if %INIT% EQU y (
	cd /D %QT_SRC%
	%PERL_DIR%\perl\bin\perl.exe init-repository ^
	--module-subset=all,-qt3d,-qtactiveqt,-qtandroidextras,-qtcanvas3d,-qtconnectivity,-qtdoc,-qtdocgallery,-qtfeedback,-qtlocation,-qtmacextras,-qtpim,-qtqa,-qtscript,-qtsensors,-qttranslations,-qtwebengine,-qtwebkit,-qtwinextras,-qtx11extras
)

cd /D %QT_SRC%
REM Get currently checked out tag
for /f "tokens=1" %%i in ('git describe') do set TAG=%%i
set /p TAG="TAG to build [%TAG%]: "
call %GIT_PATH%\bin\git.exe checkout %TAG%

cd /D %QT_BLD%
call ..\src\configure -opensource -confirm-license -debug-and-release ^
    -mp -platform win32-msvc2015 -no-icu -opengl desktop ^
	-nomake tests -nomake examples ^
	-skip qt3d ^
	-skip qtactiveqt ^
	-skip qtandroidextras ^
	-skip qtcanvas3d ^
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
	-skip qtwinextras ^
	-skip qtx11extras

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