powershell -NoProfile -ExecutionPolicy  RemoteSigned -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; "set ver 'alpha'; set dst 'C:\Software\ConEmu'; set lnk $FALSE; set xml 'https://raw.githubusercontent.com/sankhesh/BatchScripts/master/ConEmu/ConEmu.xml'; iex ((new-object net.webclient).DownloadString('https://conemu.github.io/install2.ps1'))"

REM Install Clink
powershell -NoProfile -ExecutionPolicy RemoteSigned -File %0\..\ClinkInstall.ps1 -dst C:\Software\ConEmu\ConEmu
