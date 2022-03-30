call SoftwareDrive.bat
set dst=%DRIVETOUSE%:\Software\ConEmu
start /b /wait powershell -NoProfile -ExecutionPolicy  RemoteSigned -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; "set ver 'alpha'; set dst $env:dst; set lnk $FALSE; set run $FALSE; set xml 'https://raw.githubusercontent.com/sankhesh/BatchScripts/master/ConEmu/ConEmu.xml'; iex ((new-object net.webclient).DownloadString('https://conemu.github.io/install2.ps1'))"
