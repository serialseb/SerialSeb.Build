if ($env:APPVEYOR_REPO_TAG -eq $true) {
  $coverityPublisher = (Resolve-Path "src/packages/PublishCoverity*/tools/PublishCoverity.exe").ToString()
  
  & $coverityPublisher compress -o coverity.zip -i cov-int
  if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

  & $coverityPublisher publish `
    -t "$env:coverity_token" `
    -e "$env:coverity_email" `
    -r "$env:APPVEYOR_REPO_NAME" `
    -z coverity.zip `
    -d "AppVeyor Tagged Build($env:APPVEYOR_BUILD_VERSION)." `
    --codeVersion "$env:APPVEYOR_BUILD_VERSION"
  if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
  
  Push-AppveyorArtifact coverity.zip -FileName "Coverity Report.zip"
}