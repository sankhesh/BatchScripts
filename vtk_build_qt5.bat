@ECHO OFF

SET CURRENT_DIR="%CD%"
SET CMAKE_PREFIX_PATH=F:\Software\Qt5\Qt5.5.1\5.5\msvc2013_64\lib\cmake
SET PATH=F:\Projects\CMake\install\bin;%PATH%

SET VTK_ROOT=F:\Projects\vtk
SET VTK_SRC=%VTK_ROOT%\src
SET VTK_BLD=%VTK_ROOT%\bld-opengl2-qt5-vs12

SET CLEAN_BLD=n
IF EXIST %VTK_BLD% (SET /p CLEAN_BLD="%VTK_BLD% exists. Clean build tree?[y/N]: ")
IF %CLEAN_BLD% EQU y (
	RMDIR /Q /S %VTK_BLD%
	MKDIR %VTK_BLD%)

cd /D %VTK_BLD%

CALL cmake.exe -G"Visual Studio 12 2013 Win64" ^
               -DModule_vtkGUISupportQt:BOOL=ON ^
               -DVTK_DEBUG_LEAKS:BOOL=ON ^
               -DBUILD_SHARED_LIBS:BOOL=ON ^
               -DBUILD_EXAMPLES:BOOL=OFF ^
               -DVTK_QT_VERSION:STRING=5 ^
               -DBUILD_TESTING:BOOL=OFF ^
               -DVTK_RENDERING_BACKEND:STRING=OpenGL2 ^
               %VTK_SRC%

c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /p:Configuration=Debug VTK.sln
cd /D %CURRENT_DIR%