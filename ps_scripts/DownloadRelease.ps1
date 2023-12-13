#github url to download zip file
#Assign zip file url to local variable

param(
      [string]$dst,
      [string]$url,
      [AllowEmptyString()]
      [string]$includes,
      [AllowEmptyString()]
      [string]$excludes
     )

$DownloadDir = $env:USERPROFILE + "\Downloads\"

$ZUrl = Invoke-RestMethod -uri $url | select -ExpandProperty assets | ? { $_.name.Contains(".zip") -and ([string]::IsNullOrWhiteSpace($includes) -or $_.name.Contains($includes)) -and ([string]::IsNullOrWhiteSpace($excludes) -or -not( $_.name.Contains($excludes)))} | select -expand browser_download_url

$DownloadTmpDir = $DownloadDir + "\tmp"
# if the Url from above comes up empty, try fetching the zipball_url
IF([string]::IsNullOrWhiteSpace($ZUrl)) {
  $ZUrl = Invoke-RestMethod -uri $url | select -ExpandProperty zipball_url
  $DownloadZipFile = $DownloadDir + "tmp.zip"
  Invoke-WebRequest -Uri $ZUrl -OutFile $DownloadZipFile
  Expand-Archive -Path $DownloadZipFile -DestinationPath $DownloadTmpDir -Force
  # The archive when expanded results in a folder containing the required files
  # Drop down into the subfolder and then move the relevant files to dst
  Get-ChildItem -Path $DownloadTmpDir | Get-ChildItem -Recurse | Move-Item -Destination $dst -Force 
} ELSE {
  $DownloadZipFile = $DownloadDir + $(Split-Path -Path $ZUrl -Leaf)
  IF(!(Test-Path -Path $DownloadZipFile)) {
    Invoke-WebRequest -Uri $ZUrl -OutFile $DownloadZipFile
  }
  Expand-Archive -Path $DownloadZipFile -DestinationPath $DownloadTmpDir -Force
  # Test if we have a top-level directory
  $Cnt = (Get-ChildItem -Path $DownloadTmpDir).Count
  IF ($Cnt -eq 1) {
    Get-ChildItem -Path $DownloadTmpDir | Get-ChildItem -Recurse | Move-Item -Destination $dst -Force
  } ELSE {
    Get-ChildItem -Path $DownloadTmpDir | Move-Item -Destination $dst -Force
  }
}
Remove-Item -Path $DownloadTmpDir -Recurse -Force
