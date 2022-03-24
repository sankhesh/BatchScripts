#github url to download zip file
#Assign zip file url to local variable

param(
      [string]$dst,
      [string]$url
     )

$DownloadDir = $env:USERPROFILE + "\Downloads\"

$ZUrl = Invoke-RestMethod -uri $url | select -ExpandProperty assets | ? { $_.name.Contains("zip") -and -not( $_.name.Contains("symbols"))} | select -expand browser_download_url

# if the Url from above comes up empty, try fetching the zipball_url
IF([string]::IsNullOrWhiteSpace($ZUrl)) {
  $ZUrl = Invoke-RestMethod -uri $url | select -ExpandProperty zipball_url
  $DownloadZipFile = $DownloadDir + "tmp.zip"
  Invoke-WebRequest -Uri $ZUrl -OutFile $DownloadZipFile
  $DownloadTmpDir = $DownloadDir + "\tmp"
  Expand-Archive -Path $DownloadZipFile -DestinationPath $DownloadTmpDir -Force
  # The archive when expanded results in a folder containing the required files
  # Drop down into the subfolder and then move the relevant files to dst
  Get-ChildItem -Path $DownloadTmpDir | Get-ChildItem -Recurse | Move-Item -Destination $dst 
} ELSE {
  $DownloadZipFile = $DownloadDir + $(Split-Path -Path $ZUrl -Leaf)
  Invoke-WebRequest -Uri $ZUrl -OutFile $DownloadZipFile
  Expand-Archive -Path $DownloadZipFile -DestinationPath $dst -Force
}

