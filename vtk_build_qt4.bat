@ECHO OFF

set current-dir=%cd%

set vtk-bld="F:\Projects\vtk\bld"
if not exist %vtk-bld% (
  mkdir %vtk-bld%
  cd %vtk-bld%
  call F:\Projects\CMake\install\bin\cmake.exe -DVTK_Group_Qt:BOOL=ON -DVTK_DEBUG_LEAKS:BOOL=ON -DBUILD_SHARED_LIBS:BOOL=ON -DBUILD_EXAMPLES:BOOL=OFF -DVTK_QT_VERSION:STRING=4 -DBUILD_TESTING:BOOL=OFF ..\src -G"Visual Studio 10 2010 Win64" -DQT_QMAKE_EXECUTABLE:STRING=F:/Software/Qt4/bld/bin/qmake.exe
) else (
  cd %vtk-bld%
)

c:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /m /v:m /p:Configuration=Debug VTK.sln

cd %current-dir%