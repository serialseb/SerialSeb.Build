$ErrorActionPreference = "Stop"

echo "Installing SSL Cert file to $env:SSL_CERT_FILE"
mkdir c:\ca
iwr http://curl.haxx.se/ca/cacert.pem -outfile $env:SSL_CERT_FILE

if ($env:SONARQUBE_TOKEN) {
    choco install "msbuild-sonarqube-runner" -y
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
}

$env:SSB_FUNCS = Join-Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -Child "Functions"

& $env:SSB_FUNCS/Set-EnvVars.ps1

& $env:SSB_FUNCS/Set-Version.ps1

if (test-path CHANGELOG.md -and (git tag | measure-object).Count -gt 0) {
    & $env:SSB_FUNCS/Install-Chandler.ps1
    & $env:SSB_FUNCS/Push-Chandler.ps1
}