if (-not $env:RUBY_VERSION) {
    $env:RUBY_VERSION = "21"
}

$env:CHANDLER_GITHUB_API_TOKEN=$env:GITHUB_TOKEN
$env:PATH = "C:\Ruby$env:RUBY_VERSION\bin;$env:PATH"

if (test-path "$env:APPVEYOR_BUILD_FOLDER/src/") {
    $env:SSB_SOLUTION_FILE = (Get-ChildItem "$env:APPVEYOR_BUILD_FOLDER/src/*.sln").ToString()
}

$env:SSB_PROJECT_NAME = $env:APPVEYOR_PROJECT_NAME

if (test-path "$env:APPVEYOR_BUILD_FOLDER/*.nuspec") {
    $env:SSB_NUSPEC_PATH = (Get-ChildItem "$env:APPVEYOR_BUILD_FOLDER/*.nuspec").ToString()
}
