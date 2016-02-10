SET CURRENT_DIR="%cd%"
SET CMAKE_ROOT=C:\Projects\CMake
SET CMAKE_EXE=%CMAKE_ROOT%\cmake-3.2.2-win32-x86\bin\cmake
SET CMAKE_SRC=%CMAKE_ROOT%\src
SET CMAKE_BLD=%CMAKE_ROOT%\bld
SET CMAKE_INSTALL=%CMAKE_ROOT%\install

SET CMAKE_PREFIX_PATH=C:\Projects\Qt\bld\qtbase\lib\cmake

cd /D %CMAKE_BLD%
CALL %CMAKE_EXE% -G"Visual Studio 14 2015 Win64" -DBUILD_TESTING:BOOL=OFF -DBUILD_QtDialog:BOOL=ON -DCMAKE_INSTALL_PREFIX:PATH=%CMAKE_INSTALL% %CMAKE_SRC%
c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /m /p:Configuration=Release CMake.sln
c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /m /p:Configuration=Release INSTALL.vcxproj
cd /D %CURRENT_DIR%