#github url to download zip file
#Assign zip file url to local variable

param(
      [string]$dst
     )

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
Invoke-expression "$ScriptDir\..\ps_scripts\DownloadRelease.ps1 -dst $dst -url `"https://api.github.com/repos/chrisant996/clink/releases/latest`""

# Post-install
# Rename the default-settings, default-inputrc files to ensure clink uses enhanced settings
$DefaultInputRC = $dst + "\_default_inputrc"
Move-Item -Path $DefaultInputRC -Destination "default_inputrc" -Force

# Setup autorun
$ClinkExe = $dst + "\clink_x64.exe"
$InstallCommandLine = "autorun install"
Start-Process -Verb RunAs -FilePath $ClinkExe -ArgumentList $InstallCommandLine
