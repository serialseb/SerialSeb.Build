$ErrorActionPreference = "Stop"

if ($env:SONARQUBE_TOKEN) {
    & $env:SSB_FUNCS/Publish-Coverity.ps1
    Add-AppVeyorMessage "Reporting – Coverity report uploaded"    
}
if ($env:SSB_NUSPEC_PATHS) {
    & $env:SSB_FUNCS/Create-Package.ps1
    Add-AppVeyorMessage "NuGet – Packages created"
}

if (test-path "src\Tests\bin\$env:CONFIGURATION\Tests.dll") {
    $env:SSB_TEST_ASSEMBLY = "src\Tests\bin\$env:CONFIGURATION\Tests.dll"
}