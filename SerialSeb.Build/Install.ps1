$ErrorActionPreference = "Stop"
$env:SSB_FUNCS = Join-Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -Child "Functions"

nuget update -Self -NonInteractive
$nugetClientVersion = ((nuget help) | Select-Object -first 1)
Add-AppVeyorMessage "NuGet - $nugetClientVersion"


write-host "Installing SSL Cert file to $env:SSL_CERT_FILE"
New-Item c:\ca -type directory
Invoke-WebRequest http://curl.haxx.se/ca/cacert.pem -outfile $env:SSL_CERT_FILE
Add-AppVeyorMessage "Intall - SSL Certificate updated $env:SSL_CERT_FILE"




if ($env:SONARQUBE_TOKEN) {
    choco install "msbuild-sonarqube-runner" -y
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
}



& $env:SSB_FUNCS/Set-EnvVars.ps1
if ($env:SSB_SOLUTION_FILE) {
    Add-AppVeyorMessage "Project - Solution file $env:SSB_SOLUTION_FILE"
}
else {
    Add-AppVeyorMessage "Project - No solution file found (no /src/ folder)"
}
if ($env:SSB_NUSPEC_PATHS) {
    Add-AppVeyorMessage "NuGet - Found .nuspec files" -Details "$env:SSB_NUSPEC_PATHS"
}
else {
    Add-AppVeyorMessage "NuGet - No .nuspec found"
}





& $env:SSB_FUNCS/Set-Version.ps1
Add-AppVeyorMessage "Versioning - semver '$env:SSB_VERSION_SEMVER2', base '$env:SSB_VERSION_BASE', prefix '$env:SSB_VERSION_PREFIX', nuget '$env:SSB_VERSION_NUGET'"




$tagCount = (git tag | measure-object).Count

if ((test-path CHANGELOG.md) -and ($tagCount -gt 0)) {
   & $env:SSB_FUNCS/Install-Chandler.ps1

   & $env:SSB_FUNCS/Push-Chandler.ps1

    Add-AppVeyorMessage "Versioning - Changelog uploaded"
}
else {
    Add-AppVeyorMessage "Versioning - Changelog ignored, No changelog or no tags"
}
