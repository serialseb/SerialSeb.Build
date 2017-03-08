MSBuild.SonarQube.Runner.exe end /d:"sonar.login=$env:SONARQUBE_TOKEN"
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }