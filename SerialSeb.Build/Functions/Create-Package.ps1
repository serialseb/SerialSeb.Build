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

$authors =  (git shortlog -sn --all | Where-Object { $_ -match '^\s*(?<count>\d+)\s*(?<author>.*)$' } | ForEach-Object {"$($matches["author"]) ($($matches["count"]))" }) -join ', '
$description = $repoInfo.description
if (-not $description) { $description = $repoInfo.name }

$licenseUrl = "https://github.com/$($env:APPVEYOR_REPO_NAME)/tree/$env:APPVEYOR_REPO_COMMIT/LICENSE.md"
$projectUrl = "https://github.com/$($env:APPVEYOR_REPO_NAME)/"

write-host "Release notes: $releaseNotes"
write-host "License URL: $licenseUrl"
write-host "Authors: $authors"
write-host "Project URL: $projectUrl"
write-host "Description: $description"

$nuspecs = ($env:SSB_NUSPEC_PATHS -split ";")

$nuspecs | ForEach-Object {
    $nuspecPath = $_
    $nuspecFile = get-childitem $nuspecPath
    $nuspecBasePath = "$($nuspecFile.Directory)\"
    $nuPkgPath = $_.ToString().Replace(".nuspec", ".$($env:SSB_VERSION_NUGET).nupkg")
    $nuPkgDeployName = $nuspecBasePath | resolve-path -relative
    $noPackageAnalysis = ""
    if ($env:NUGET_NO_PACKAGE_ANALYSIS) {
        $noPackageAnalysis = "-NoPackageAnalysis"
    }
    & nuget pack "$nuspecPath" `
        -Version $env:SSB_VERSION_NUGET `
        -BasePath "$nuspecBasepath" `
        -OutputDirectory "$nuspecBasePath" `
        -NonInteractive $noPackageAnalysis `
        -Properties releaseNotes="$releaseNotes"`;authors="$authors"`;licenseUrl="$licenseUrl"`;projectUrl="$projectUrl"`;description="$description"
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
    Push-AppveyorArtifact $nuPkgPath -DeploymentName $nuPkgDeployname
}