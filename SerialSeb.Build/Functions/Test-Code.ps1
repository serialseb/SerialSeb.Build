$xunit = (Resolve-Path "src/packages/xunit.runner.console/tools/xunit.console.exe").ToString()
$opencover = (Resolve-Path "src/packages/OpenCover/tools/OpenCover.Console.exe").ToString()
$coveralls = (Resolve-Path "src/packages/coveralls.net/tools/csmacnz.Coveralls.exe").ToString()

& $opencover -register:user -target:$xunit  -returntargetcode "-targetargs:""src\Tests\bin\$env:CONFIGURATION\Tests.dll"" -noshadow -appveyor -xml XUnitResults.xml" -filter:"+[*]* -[*]Json.*" -output:opencoverCoverage.xml -searchdirs:"src\$env:SSB_PROJECT_NAME\bin\$env:CONFIGURATION\"
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

if ($env:COVERALLS_TOKEN) {
    & $coveralls --opencover -i opencoverCoverage.xml --repoToken $env:COVERALLS_REPO_TOKEN --commitId $env:APPVEYOR_REPO_COMMIT --commitBranch $env:APPVEYOR_REPO_BRANCH --commitAuthor $env:APPVEYOR_REPO_COMMIT_AUTHOR --commitEmail $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL --commitMessage $env:APPVEYOR_REPO_COMMIT_MESSAGE --jobId $env:APPVEYOR_JOB_ID
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
}

Push-AppveyorArtifact opencoverCoverage.xml
Push-AppveyorArtifact XUnitResults.xml
