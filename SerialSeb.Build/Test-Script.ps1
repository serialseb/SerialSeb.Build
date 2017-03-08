$ErrorActionPreference = "Stop"

if ($env:SSB_TEST_ASSEMBLY) {
    & $env:SSB_FUNCS/Test-Code.ps1
}
if ($env:SONARQUBE_TOKEN) {
    & $env:SSB_FUNCS/End-SonarQube.ps1
}
