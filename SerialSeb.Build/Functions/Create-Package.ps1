$repo = $env:APPVEYOR_REPO_NAME

function Get-GitHubRepo([string]$uri="") {
    if ($uri -ne "" -and -not $uri.StartsWith("/")) { $uri = "/$uri" }
    $finalUri = "https://api.github.com/repos/$repo$uri" + '?access_token=' + "$($env:GITHUB_TOKEN)"
    Invoke-WebRequest -Uri $finalUri | ConvertFrom-Json
}

$releaseNotes = 'Pre-release, see https://github.com/serialseb/ConsulStructure/blob/master/CHANGELOG.md for the latest details'
$repoInfo = Get-GitHubRepo

if ($env:APPVEYOR_REPO_TAG -eq $true) {
    $releaseNotes = (Get-GitHubRepo "releases/tags/$($env:APPVEYOR_REPO_TAG_NAME)").body.Replace('"','\"').Replace('### ', '')
}

$authors =  (git shortlog -sn --all | ? { $_ -match '^\s*(?<count>\d+)\s*(?<author>.*)$' } | % {"$($matches["author"]) ($($matches["count"]))" }) -join ', '
$description = $repoInfo.description
if (-not $description) { $description = $repoInfo.name }

$licenseUrl = "https://github.com/$($env:APPVEYOR_REPO_NAME)/tree/$env:APPVEYOR_REPO_COMMIT/LICENSE.md"
$projectUrl = "https://github.com/$($env:APPVEYOR_REPO_NAME)/"
$nuspecPath = $env:SSB_NUSPEC_PATH

if (-not (test-path $nuspecPath)) { exit }

write-host "Release notes: $releaseNotes"
write-host "License URL: $licenseUrl"
write-host "Authors: $authors"
write-host "Project URL: $projectUrl"
write-host "Description: $description"

$nuspecs = $env:SSB_NUSPEC_PATHS -split ";"

$nuspecs | ForEach-Object {
    $nuspecPath = $_
    $nuspecBasePath = "$((get-childitem $_).Directory)\"


    Write-Host "nuget pack `"$nuspecPath`" -version $env:NUGET_VERSION -basepath `"$nuspecBasePath`""

    & nuget pack "$nuspecPath" `
        -version $env:NUGET_VERSION `
        -basepath "$nugetBasepath" `
        -NonInteractive `
        -Properties releaseNotes="$releaseNotes"`;authors="$authors"`;licenseUrl="$licenseUrl"`;projectUrl="$projectUrl"`;description="$description"
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
}

Push-AppveyorArtifact *.nupkg