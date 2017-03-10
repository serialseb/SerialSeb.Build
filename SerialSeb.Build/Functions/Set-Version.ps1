$baseVersion = $(cat VERSION)
$version = [version]$baseVersion
$build = $env:APPVEYOR_BUILD_NUMBER
$major = $version.Major
$branch = $env:APPVEYOR_REPO_BRANCH

if ($env:APPVEYOR_REPO_TAG -eq $true) {
    $version = $env:APPVEYOR_REPO_TAG_NAME
    $buildVersionPrefix = $version
    $nugetVersion = $version
}
else {
    # $buildsForBranch = "/api/projects/$env:APPVEYOR_ACCOUNT_NAME/$env:APPVEYOR_PROJECT_SLUG/history?recordsNumber=4000&branch=$branch"
    # $lastBuild = (Invoke-WebRequest -Uri $buildsForBranch) | ConvertFrom-Json
    # $lastBuildVersion = $lastBuild.build.version

    if ($branch -eq 'master') {
        $buildVersionSuffix = "ci"
    }
    else {
        $buildVersionSuffix = "b-$branch"
    }
    $buildVersionPrefix = "$baseVersion-$buildVersionSuffix"
    $version = "$buildVersionPrefix+$build"

    
    $nugetBuild = "-$($build | ForEach-Object PadLeft 4 '0')"
    $nugetSuffix = $buildVersionSuffix.Substring(0,[math]::min(15, $buildVersionSuffix.Length))
    
    $nugetVersion = "$baseVersion-$nugetSuffix$nugetBuild"
}
$env:SSB_VERSION_BASE = $baseVersion
$env:SSB_VERSION_PREFIX = $buildVersionPrefix
$env:SSB_VERSION_NUGET = $nugetVersion
$env:SSB_VERSION_SEMVER2 = $version

Set-AppveyorBuildVariable -Name "AssemblyMajor" -Value "$major"
Update-AppVeyorBuild -Version $env:SSB_VERSION_SEMVER2
