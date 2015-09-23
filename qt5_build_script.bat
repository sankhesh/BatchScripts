@ECHO OFF
set QMAKESPEC=win32-msvc2010
set QTDIR=F:\Software\Qt5\bld\qtbase
set PATH=F:\Software\Qt5\bld\bin;F:\Software\Qt5\src\gnuwin32\bin;%PATH%

rem Include libICU for webkit
set INCLUDE=%INCLUDE%;F:\Software\icu4c-54_1-Win64-msvc10\icu\include
set LIB=%LIB%;F:\Software\icu4c-54_1-Win64-msvc10\icu\lib64

rmdir /Q /S F:\Software\Qt5\bld
mkdir F:\Software\Qt5\bld
rem cd /D F:\Software\Qt5\src
rem perl init-repository
cd /D F:\Software\Qt5\bld
call ..\src\configure -opensource -confirm-license -debug-and-release -mp -platform win32-msvc2010 -opengl desktop -nomake tests
nmake
rem call F:\Software\jom_1_0_14\jom.exe
rem nmake qdoc3
rem editbin /STACK:0x200000 bin\qdoc3.exe
rem nmake docs
nmake install
nmake clean
cd ..