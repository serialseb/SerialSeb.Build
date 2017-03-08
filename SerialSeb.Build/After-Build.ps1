$ErrorActionPreference = "Stop"

if ($env:SONARQUBE_TOKEN) {
    & $env:SSB_FUNCS/Publish-Coverity.ps1
}

& $env:SSB_FUNCS/Create-Package.ps1

if (test-path "src\Tests\bin\$env:CONFIGURATION\Tests.dll") {
    $env:SSB_TEST_ASSEMBLY = "src\Tests\bin\$env:CONFIGURATION\Tests.dll"
}