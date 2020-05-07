@ECHO OFF
setlocal enableextensions enabledelayedexpansion

SET CURRENT_DIR="%cd%"

REM Useful variables that should be set for the script to run
SET CMAKE_ROOT=C:\Projects\CMake
SET CMAKE_EXE=C:\Software\cmake\bin\cmake.exe
rem SET GIT_PATH="%PROGRAMFILES%\Git"
FOR /f "tokens=1" %%i IN ('where git') DO SET GIT_EXE=%%i

SET CMAKE_SRC=%CMAKE_ROOT%\cmake
SET CMAKE_BLD=%CMAKE_ROOT%\bld
SET CMAKE_INSTALL=%CMAKE_ROOT%\install
SET QT_PATH=C:\Projects\Qt\install

SET CMAKE_PREFIX_PATH=C:\Projects\Qt\install\lib\cmake

SET SRC_EXISTED=1
IF NOT EXIST %CMAKE_SRC% (
	CALL %GIT_EXE% clone https://gitlab.kitware.com/cmake/cmake.git/ %CMAKE_SRC%
  set SRC_EXISTED=0
)

SET CLEAN_BLD=n
IF %SRC_EXISTED% GTR 0 (
  IF EXIST %CMAKE_BLD% (SET /p CLEAN_BLD="%CMAKE_BLD% exists. Clean build tree?[y/N]: ")
) ELSE (
  SET CLEAN_BLD=y
)

IF %CLEAN_BLD% EQU y (
  RMDIR /Q /S %CMAKE_BLD%
)
MKDIR %CMAKE_BLD%

CD /D %CMAKE_SRC%
IF %SRC_EXISTED% GTR 0 (
  CALL %GIT_EXE% fetch origin --tags --prune
)

REM Get currently checked out tag
FOR /F "tokens=1" %%i IN ('%GIT_EXE% describe') DO SET TAG=%%i
SET /P TAG="TAG to build [%TAG%] (Enter 't' to list all tags): "
:WHILE1
  IF /I !TAG! EQU t (
    CALL %GIT_EXE% tag -l --sort -version:refname
    FOR /F "tokens=1"  %%i IN ('%GIT_EXE% describe') DO SET TAG=%%i
    SET /P TAG="TAG to build [!TAG!] (Enter 't' to list all tags): "
    GOTO :WHILE1
  )
ECHO "Checking out tag: %TAG%"
CALL %GIT_EXE% checkout %TAG%

CD /D %CMAKE_BLD%
CALL %CMAKE_EXE% -G"Visual Studio 16 2019" -A"x64" ^
 -DBUILD_TESTING:BOOL=OFF ^
 -DBUILD_QtDialog:BOOL=ON ^
 -DCMAKE_PREFIX_PATH:PATH=%QT_PATH%\lib\cmake ^
 -DCMAKE_INSTALL_PREFIX:PATH=%CMAKE_INSTALL% ^
 %CMAKE_SRC%
MSBuild.exe /v:m /m /p:Configuration=Release CMake.sln
MSBuild.exe /v:m /m /p:Configuration=Release INSTALL.vcxproj

rem The following commands require Developer Mode to be enabled on Windows 10
IF NOT EXIST %CMAKE_INSTALL%\bin\Qt5Widgets.dll (
  MKLINK %CMAKE_INSTALL%\bin\Qt5Widgets.dll %QT_PATH%\bin\Qt5Widgets.dll
  MKLINK %CMAKE_INSTALL%\bin\Qt5Core.dll %QT_PATH%\bin\Qt5Core.dll
  MKLINK %CMAKE_INSTALL%\bin\Qt5Gui.dll %QT_PATH%\bin\Qt5Gui.dll
  MKLINK %CMAKE_INSTALL%\bin\Qt5WinExtras.dll %QT_PATH%\bin\Qt5WinExtras.dll
  MKLINK /d %CMAKE_INSTALL%\bin\plugins %QT_PATH%\plugins
)
cd /D %CURRENT_DIR%