# Download latest dotnet/codeformatter release from github

param(
      [string]$repo
     )

$releases = "https://api.github.com/repos/$repo/releases/latest"
Write-Output $releases

# param(
#       [string]$repo,
#       [string]$filename,
#       [string]$arch
#      )
# Write-Host Determining latest release
# $tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

# $file = "$filename" + "_" + $tag + "_" + "$arch.zip"

# $download_url = "https://github.com/$repo/releases/download/$tag/$file"

# Write-Output $download_url
