$ErrorActionPreference = "Stop"

if ($env:SSB_SOLUTION_FILE) {
    & $env:SSB_FUNCS/Build-Solution.ps1
    Add-AppVeyorMessage "Project - Solution built" -Details $env:SSB_SOLUTION_FILE
}