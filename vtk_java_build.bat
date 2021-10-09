@ECHO OFF

REM Load the vs variables
"%PROGRAMFILES(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

SET CURRENT_DIR="%CD%"

REM Adjust the following variables based on preferences
SET JAVA_HOME=C:\Software\JDK
SET VTK_ROOT=C:\Projects\VTK
SET VTK_SRC=%VTK_ROOT%\VTK
SET VTK_BLD=%VTK_ROOT%\bld
SET CMAKE_PATH=C:\Projects\CMake\install\bin
SET BUILD_TYPE=Release
SET GIT_EXE=C:\Software\git\bin\git.exe

REM The main logic starts here
SET PATH=%CMAKE_PATH%;%PATH%
SET CMAKE_PREFIX_PATH=%JAVA_HOME%;%JAVA_HOME%\bin;%JAVA_HOME%\lib;%JAVA_HOME%\include;%CMAKE_PREFIX_PATH%

if NOT EXIST %VTK_SRC% (
  REM Clone the repository
  CALL %GIT_EXE% clone https://gitlab.kitware.com/vtk/vtk.git %VTK_SRC%
) ELSE (
  REM Checkout the git revision of choice
  CD /D %VTK_SRC%
  CALL %GIT_EXE% fetch origin --prune
  CALL %GIT_EXE% reset --hard ebcaba9ebec55169c2adee45e6dbfcda275161cd
)

if NOT EXIST %VTK_SRC% (
  EXIT /B 1
)

SET CLEAN_BLD=n
IF EXIST %VTK_BLD% (
	SET /p CLEAN_BLD="%VTK_BLD% exists. Clean build tree?[y/N]: "
) ELSE (
	MKDIR %VTK_BLD%
)

IF %CLEAN_BLD% EQU y (
	RMDIR /Q /S %VTK_BLD%
	MKDIR %VTK_BLD%
)

cd /D %VTK_BLD%

CALL cmake.exe -G"Ninja" ^
               -DCMAKE_C_COMPILER:FILEPATH=cl.exe ^
               -DCMAKE_CXX_COMPILER:FILEPATH=cl.exe ^
               -DCMAKE_LINKER:FILEPATH=link.exe ^
               -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
               -DVTK_WRAP_JAVA:BOOL=ON ^
               -DVTK_BUILD_EXAMPLES:BOOL=OFF ^
               -DVTK_BUILD_TESTING:STRING=OFF ^
               %VTK_SRC%

CALL ninja

cd /D %CURRENT_DIR%
