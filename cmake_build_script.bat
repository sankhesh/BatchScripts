SET CURRENT_DIR="%cd%"

REM Useful variables that should be set for the script to run
SET CMAKE_ROOT=D:\Projects\CMake
SET CMAKE_EXE=D:\Software\cmake-3.5-rc1\bin\cmake
SET GIT_PATH="%PROGRAMFILES%\Git"

SET CMAKE_SRC=%CMAKE_ROOT%\src
SET CMAKE_BLD=%CMAKE_ROOT%\bld
SET CMAKE_INSTALL=%CMAKE_ROOT%\install

SET CMAKE_PREFIX_PATH=D:\Projects\Qt\bld\qtbase\lib\cmake

IF NOT EXIST %CMAKE_SRC% (
	CALL %GIT_PATH%\bin\git.exe clone git://cmake.org/cmake.git %CMAKE_SRC%
)

IF NOT EXIST %CMAKE_BLD% (
	mkdir %CMAKE_BLD%
)

cd /D %CMAKE_BLD%
CALL %CMAKE_EXE% -G"Visual Studio 14 2015 Win64" -DBUILD_TESTING:BOOL=OFF -DBUILD_QtDialog:BOOL=ON -DCMAKE_INSTALL_PREFIX:PATH=%CMAKE_INSTALL% %CMAKE_SRC%
c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /m /p:Configuration=Release CMake.sln
c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /m /p:Configuration=Release INSTALL.vcxproj
cd /D %CURRENT_DIR%