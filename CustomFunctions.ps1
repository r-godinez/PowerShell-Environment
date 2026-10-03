# Automatically load all script files in the Functions folder
Get-ChildItem -Path "$PSScriptRoot\Functions\*.ps1" | ForEach-Object {
    . $_.FullName
}
