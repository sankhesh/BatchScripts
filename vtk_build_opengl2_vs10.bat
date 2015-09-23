@ECHO OFF

set current-dir=%cd%

set vtk-bld="F:\Projects\vtk\bld-opengl2-vs10"
if not exist %vtk-bld% ( 
  mkdir %vtk-bld%
  cd %vtk-bld%
  call F:\Projects\CMake\install\bin\cmake.exe -DVTK_RENDERING_BACKEND:STRING=OpenGL2 -DVTK_DEBUG_LEAKS:BOOL=ON -DBUILD_TESTING:BOOL=OFF ..\src -G"Visual Studio 10 2010 Win64"
) else (
  cd %vtk-bld%
)

c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /v:m /m /p:Configuration=Debug VTK.sln

cd %current-dir%