@ECHO OFF

SET CURRENT_DIR="%cd%"

REM Useful variables that should be set for the script to run
SET CMAKE_ROOT=D:\Projects\CMake
SET CMAKE_EXE=D:\Software\CMake\cmake-3.13.4-win64-x64\bin\cmake.exe
SET GIT_PATH="%PROGRAMFILES%\Git"

SET CMAKE_SRC=%CMAKE_ROOT%\cmake
SET CMAKE_BLD=%CMAKE_ROOT%\bld
SET CMAKE_INSTALL=%CMAKE_ROOT%\install

SET CMAKE_PREFIX_PATH=D:\Projects\Qt\install\lib\cmake

IF NOT EXIST %CMAKE_SRC% (
	CALL %GIT_PATH%\bin\git.exe clone git://cmake.org/cmake.git %CMAKE_SRC%
)

IF NOT EXIST %CMAKE_BLD% (
	mkdir %CMAKE_BLD%
)

cd /D %CMAKE_BLD%
CALL %CMAKE_EXE% -G"Visual Studio 15 2017 Win64" -DBUILD_TESTING:BOOL=OFF -DBUILD_QtDialog:BOOL=ON -DCMAKE_INSTALL_PREFIX:PATH=%CMAKE_INSTALL% %CMAKE_SRC%
MSBuild.exe /v:m /m /p:Configuration=Release CMake.sln
MSBuild.exe /v:m /m /p:Configuration=Release INSTALL.vcxproj
cd /D %CURRENT_DIR%