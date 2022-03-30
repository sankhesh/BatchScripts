@ECHO off
call SoftwareDrive.bat
set dst=%DRIVETOUSE%:\Software\ConEmu
start /b /wait powershell -NoProfile -ExecutionPolicy  RemoteSigned -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; "set ver 'alpha'; set dst $env:dst; set lnk $FALSE; set run $FALSE; set xml 'https://raw.githubusercontent.com/sankhesh/BatchScripts/master/ConEmu/ConEmu.xml'; iex ((new-object net.webclient).DownloadString('https://conemu.github.io/install2.ps1'))"
set conf=%DRIVETOUSE%:\Software\ConEmu\ConEmu.xml
set mypath=%~dp0
set lntarget=%mypath%ConEmu.xml
echo Setup the symlink manually using: "del /q %conf% && mklink %conf% %lntarget%"
