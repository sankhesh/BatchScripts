#github url to download zip file
#Assign zip file url to local variable

param(
      [string]$dst
     )

$Url = "https://github.com/chrisant996/clink/releases/download/v1.3.9/clink.1.3.9.2e99f4.zip"

$DownloadDir = $env:USERPROFILE + "\Downloads\"

$DownloadZipFile = $DownloadDir + $(Split-Path -Path $Url -Leaf)

$ExtractPath = $dst + "\clink\"

write-output $ExtractPath

Invoke-WebRequest -Uri $Url -OutFile $DownloadZipFile

Expand-Archive -Path $DownloadZipFile -DestinationPath $ExtractPath
