[![Build Status](https://ci.appveyor.com/api/projects/status/mp5v36y4lg76ppju?svg=true)](https://ci.appveyor.com/project/OpenRasta/SerialSeb.Build)
[![GitHub release](https://img.shields.io/github/release/serialseb/SerialSeb.Build.svg)](https://github.com/serialseb/SerialSeb.Build/releases/latest)
[![NuGet](https://img.shields.io/nuget/v/SerialSeb.Build.svg)](https://www.nuget.org/packages/SerialSeb.Build/)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/serialseb/SerialSeb.Build.svg)](https://github.com/serialseb/ConsulStructure/pulls)

# Build files

## What is it?

Those build files are what I use to do a bunch of things across my projects. 
It's convention-based, so it expects stuff where it expectx it, so stop moaning
and just put the damn source files in the src folder.

The SerialSeb Build system supports the following features:

 - SemVer 2 (and NuGet "reduced experience") based on a VERSION file and tags
 - NuGet packaging based on GitHub repository information
 - Source-only packages for both old and new NuGet content
 - Automatically run tests and send coverage reports to SonarQube, Coverity and
   coveralls.io
 - Keep CHANGELOG.md sync'd up with releaes in GitHub

## How do I use them

They're built for me, but happy to take pull requests, *if* it doesn't increase
complexity too much.

On AppVeyor, you add the following to your appeyor.yml.

```yml
install:
  - nuget install SerialSeb.Build -Pre -OutputDirectory . -ExcludeVersion
  - ps: ./SerialSeb.Build/Install.ps1

before_build:
  - ps: ./SerialSeb.Build/Before-Build.ps1

build_script:
  - ps: ./SerialSeb.Build/Build-Script.ps1

after_build:
  - ps: ./SerialSeb.Build/After-Build.ps1

test_script:
- ps: ./SerialSeb.Build/Test-Script.ps1

```

You can set environment variables to control what gets done on build.

```
environment:
  SONARQUBE_TOKEN: your sonarqube token
  SSL_CERT_FILE: The SSL cert to install for gems to actually do something
  COVERALLS_REPO_TOKEN: your coveralls token
  GITHUB_TOKEN: your github token
  coverity_token: your coverity token
  coverity_email: the coverity email to send notifications to
```
