@ECHO OFF

set CURRENT_DIR="%CD%"

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

set PYTHON_DIR=D:\Software\Python2.7.11\
set PERL_DIR=D:\Software\StrawberryPerl5.22.1.2\
set JOM_DIR=D:\Software\jom_1_1_0\
set QT_PATH=D:\Software\Qt

set QMAKESPEC=win32-msvc2015
set QT_SRC=%QT_PATH%\src
set QT_BLD=%QT_PATH%\bld
set QTDIR=%QT_BLD%\qtbase
set PATH=%QT_BLD%\bin;%QT_SRC%\qtrepotools\bin;%QT_SRC%\gnuwin32\bin;%PYTHON_DIR%;"%PROGRAMFILES%\Git\bin";%PATH%

rem Include libICU for webkit
rem set INCLUDE=%INCLUDE%;F:\Software\icu4c-54_1-Win64-msvc10\icu\include
rem set LIB=%LIB%;F:\Software\icu4c-54_1-Win64-msvc10\icu\lib64

set CLEAN_BLD=n
if EXIST %QT_BLD% (SET /p CLEAN_BLD="%QT_BLD% exists. Clean build tree?[y/N]: ")
if %CLEAN_BLD% EQU y (
	rmdir /Q /S %QT_BLD%
	mkdir %QT_BLD%
)

set INIT=n
set /p INIT="Initialize Qt submodules?[y/N]: "
if %INIT% EQU y (
	cd /D %QT_SRC%
	%PERL_DIR%\perl\bin\perl.exe init-repository -f --no-webkit
)

cd /D %QT_BLD%
call ..\src\configure -opensource -confirm-license -debug-and-release -mp -platform win32-msvc2015 -no-icu -opengl desktop -nomake tests -nomake examples

call %JOM_DIR%\jom.exe
call %JOM_DIR%\jom.exe install

rem nmake
rem nmake qdoc3
rem editbin /STACK:0x200000 bin\qdoc3.exe
rem nmake docs
rem nmake install
rem nmake clean
cd /D %CURRENT_DIR%