& $env:SSB_OPENCOVER_PATH -register:user -target:$env:SSB_XUNIT_PATH -returntargetcode "-targetargs:""src\Tests\bin\$env:CONFIGURATION\Tests.dll"" -noshadow -appveyor -xml XUnitResults.xml" -filter:"+[*]* -[*]Json.*" -output:opencoverCoverage.xml -searchdirs:"src\$env:SSB_PROJECT_NAME\bin\$env:CONFIGURATION\"
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }

if ($env:COVERALLS_TOKEN) {
    & $env:SSB_COVERALLS_PATH --opencover -i opencoverCoverage.xml --repoToken $env:COVERALLS_REPO_TOKEN --commitId $env:APPVEYOR_REPO_COMMIT --commitBranch $env:APPVEYOR_REPO_BRANCH --commitAuthor $env:APPVEYOR_REPO_COMMIT_AUTHOR --commitEmail $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL --commitMessage $env:APPVEYOR_REPO_COMMIT_MESSAGE --jobId $env:APPVEYOR_JOB_ID
    if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }
}

Push-AppveyorArtifact opencoverCoverage.xml
Push-AppveyorArtifact XUnitResults.xml
