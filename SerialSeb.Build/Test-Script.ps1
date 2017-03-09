$ErrorActionPreference = "Stop"

if ($env:SSB_TEST_ASSEMBLY) {
    & $env:SSB_FUNCS/Test-Code.ps1
    Add-AppVeyorMessage "Tests – Ran tests." -Details $env:SSB_TEST_ASSEMBLY
} else {
    Add-AppVeyorMessage "Tests – No test assembly detected"
}
if ($env:SONARQUBE_TOKEN) {
    & $env:SSB_FUNCS/End-SonarQube.ps1
    Add-AppVeyorMessage "Reporting – SonarQube report uploaded."
}
