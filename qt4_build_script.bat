@ECHO OFF
set QMAKESPEC=win32-msvc2010
set QTDIR=F:\Software\Qt4\bld
rmdir /Q /S F:\Software\Qt4\bld
mkdir F:\Software\Qt4\bld
cd /D F:\Software\Qt4\bld
..\src\configure -opensource -confirm-license -debug-and-release -mp -platform win32-msvc2010
nmake
nmake qdoc3
editbin /STACK:0x200000 bin\qdoc3.exe
nmake docs
nmake install
nmake clean
cd ..