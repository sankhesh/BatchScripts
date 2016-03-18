@ECHO OFF

SET CURRENT_DIR="%CD%"

SET QT_BLD=D:\Projects\Qt\bld
SET CMAKE_PREFIX_PATH=%QT_BLD%\qtbase\lib\cmake
SET PATH=D:\Projects\CMake\install\bin;%PATH%

SET VTK_ROOT=D:\Projects\vtk
SET VTK_SRC=%VTK_ROOT%\src
SET VTK_BLD=%VTK_ROOT%\bld

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

CALL cmake.exe -G"Visual Studio 14 2015 Win64" ^
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