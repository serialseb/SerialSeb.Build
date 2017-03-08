nuget restore $env:SSB_SOLUTION_FILE
if ($env:SONARQUBE_TOKEN) {
    & $env:SSB_FUNCS/Begin-SonarQube.ps1
}