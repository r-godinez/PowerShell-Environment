# 1. Folder & File Hierarchy
Write-Host "=== FOLDER STRUCTURE ===" -ForegroundColor Yellow
Get-ChildItem -Path "$HOME\Scripts" -Recurse -Force | Select-Object @{Name="RelativePath"; Expression={$_.FullName.Replace("$HOME\", "")}}, Length, LastWriteTime

# 2. File Contents
Write-Host "`n=== FILE CONTENTS ===" -ForegroundColor Yellow
Get-ChildItem -Path "$HOME\Scripts" -Recurse -File | ForEach-Object {
    Write-Host "`n--- File: $($_.FullName) ---" -ForegroundColor Cyan
    Get-Content $_.FullName
}

# 3. Profile Setup Status
Write-Host "`n=== ACTIVE PROFILE ($PROFILE) ===" -ForegroundColor Yellow
if (Test-Path $PROFILE) {
    Get-Content $PROFILE
} else {
    Write-Host "Profile file does not exist yet." -ForegroundColor Red
}

# 4. Active Function Verification
Write-Host "`n=== FUNCTION LOAD STATUS ===" -ForegroundColor Yellow
if (Get-Command Install-WingetApps -ErrorAction SilentlyContinue) {
    Write-Host "SUCCESS: Install-WingetApps is currently loaded in memory!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Install-WingetApps is NOT loaded in this session." -ForegroundColor Red
}