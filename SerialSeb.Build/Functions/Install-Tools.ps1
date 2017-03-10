nuget install xunit.runner.console -NonInteractive -OutputDirectory .tools -ExcludeVersion
nuget install OpenCover -NonInteractive -OutputDirectory .tools -ExcludeVersion
nuget install coveralls.net -NonInteractive -OutputDirectory .tools -ExcludeVersion

$env:SSB_XUNIT_PATH = (Resolve-Path ".tools/xunit.runner.console/tools/xunit.console.exe")
$env:SSB_OPENCOVER_PATH = (Resolve-Path ".tools/OpenCover/tools/OpenCover.Console.exe")
$env:SSB_COVERALLS_PATH = (Resolve-Path ".tools/coveralls.net/tools/csmacnz.Coveralls.exe")
