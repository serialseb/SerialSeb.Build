$ErrorActionPreference = "Stop"

if ($env:SSB_SOLUTION_FILE) {
    nuget restore $env:SSB_SOLUTION_FILE
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
}

if ($env:SONARQUBE_TOKEN) {
    & $env:SSB_FUNCS/Begin-SonarQube.ps1
}