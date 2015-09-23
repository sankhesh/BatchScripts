@ECHO OFF

SET CMAKE_PREFIX_PATH=F:\Software\Qt5\bld\qtbase\lib\cmake

rmdir /Q /S F:\Projects\vtk\bld-opengl2-qt5-vs10
mkdir F:\Projects\vtk\bld-opengl2-qt5-vs10
cd /D F:\Projects\vtk\bld-opengl2-qt5-vs10

call F:\Projects\CMake\install\bin\cmake.exe -DVTK_Group_Qt:BOOL=ON -DVTK_DEBUG_LEAKS:BOOL=ON -DBUILD_SHARED_LIBS:BOOL=ON -DBUILD_EXAMPLES:BOOL=OFF -DVTK_QT_VERSION:STRING=5 -DBUILD_TESTING:BOOL=OFF -DVTK_RENDERING_BACKEND:STRING=OpenGL2 ..\src -G"Visual Studio 10 2010 Win64"
c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /p:Configuration=Debug VTK.sln