@ECHO OFF

rem Set up \Microsoft Visual Studio 2015, where <arch> is \c amd64, \c x86, etc.
rem No need to do this if running from Visual Studio Native Tools x64 command prompt
rem CALL "C:\Program Files(x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

set QMAKESPEC=win32-msvc2015
set QTDIR=C:\Projects\Qt\bld\qtbase
set PATH=C:\Projects\Qt\bld\bin;C:\Projects\Qt\src\qtrepotools\bin;C:\Projects\Qt\src\gnuwin32\bin;C:\Python27\;"%PROGRAMFILES(x86)%\Git\bin";%PATH%

rem Include libICU for webkit
rem set INCLUDE=%INCLUDE%;F:\Software\icu4c-54_1-Win64-msvc10\icu\include
rem set LIB=%LIB%;F:\Software\icu4c-54_1-Win64-msvc10\icu\lib64

rem rmdir /Q /S C:\Projects\Qt\bld
rem mkdir C:\Projects\Qt\bld
cd /D C:\Projects\Qt\src
C:\StrawberryPerl\perl\bin\perl.exe init-repository --no-webkit
cd /D C:\Projects\Qt\bld
call ..\src\configure -opensource -confirm-license -debug-and-release -mp -platform win32-msvc2015 -no-icu -opengl desktop -nomake tests -nomake examples
rem nmake
call C:\Projects\Qt\jom\jom.exe
call C:\Projects\Qt\jom\jom.exe install
rem nmake qdoc3
rem editbin /STACK:0x200000 bin\qdoc3.exe
rem nmake docs
rem nmake install
rem nmake clean
cd ..