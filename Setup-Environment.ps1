# Setup-Environment.ps1 - Master Setup Script for Windows 11
[CmdletBinding()]
param(
    [string]$GitName = "Ricardo Godinez",
    [string]$GitEmail = "rgodinezco@gmail.com"
)

$ErrorActionPreference = "Stop"
Write-Host "=== Starting Windows 11 Environment Setup ===" -ForegroundColor Green

# ---------------------------------------------------------------------------
# 1. Create Directory Hierarchy
# ---------------------------------------------------------------------------
Write-Host "`n[1/6] Creating directory structure..." -ForegroundColor Cyan
$ScriptsDir = "$HOME\Scripts"
$FunctionsDir = "$ScriptsDir\Functions"

New-Item -Path $FunctionsDir -ItemType Directory -Force | Out-Null

# ---------------------------------------------------------------------------
# 2. Create Modular Function Files
# ---------------------------------------------------------------------------
Write-Host "[2/6] Writing modular function files..." -ForegroundColor Cyan

# Software Management
@'
function Install-WingetApps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string[]]$AppIds = @(
            "wez.wezterm",
            "WabbajackTools.Wabbajack",
            "SoftDeluxe.FreeDownloadManager"
        )
    )

    foreach ($id in $AppIds) {
        Write-Host "`n[+] Installing package: $id" -ForegroundColor Cyan
        winget install --id $id --exact --accept-package-agreements --accept-source-agreements
    }
}
'@ | Out-File -FilePath "$FunctionsDir\Software.ps1" -Encoding utf8 -Force

# System Maintenance
@'
function Get-SystemSummary {
    param(
        [string]$ComputerName =$env:COMPUTERNAME
    )

    Write-Host "Fetching status for $ComputerName..." -ForegroundColor Cyan
    Get-CimInstance Win32_OperatingSystem | Select-Object Caption, OSArchitecture, FreePhysicalMemory
}

function Clear-UserTemp {
    [CmdletBinding()]
    param()

    Write-Verbose "Cleaning Windows Temp folder..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp files cleared!" -ForegroundColor Green
}
'@ | Out-File -FilePath "$FunctionsDir\Maintenance.ps1" -Encoding utf8 -Force

# Directory Navigation & Organization
@'
function Clean-HomeDir {
    [CmdletBinding()]
    param()

    Write-Host "[+] Cleaning $HOME directory..." -ForegroundColor Cyan

    if (Test-Path "$HOME\get-configs.ps1") {
        Move-Item -Path "$HOME\get-configs.ps1" -Destination "$HOME\Scripts\Functions\Get-Configs.ps1" -Force
        Write-Host "  -> Moved get-configs.ps1 to Scripts\Functions\" -ForegroundColor Green
    }

    if (Test-Path "$HOME\Scripts\.wslconfig") {
        Copy-Item -Path "$HOME\Scripts\.wslconfig" -Destination "$HOME\.wslconfig" -Force
        Write-Host "  -> Synced .wslconfig" -ForegroundColor Green
    }

    Get-ChildItem -Path $HOME -Filter "*.tmp" -ErrorAction SilentlyContinue | Remove-Item -Force
    if (Test-Path "$HOME\temp.ps1") {
        Remove-Item -Path "$HOME\temp.ps1" -Force
        Write-Host "  -> Removed temp.ps1" -ForegroundColor Green
    }

    Write-Host "[+] $HOME cleanup complete!" -ForegroundColor Green
}

function Go-Scripts { Set-Location "$HOME\Scripts" }
function Go-Home    { Set-Location $HOME }
'@ | Out-File -FilePath "$FunctionsDir\Navigation.ps1" -Encoding utf8 -Force

# Placeholder for Get-Configs
if (!(Test-Path "$FunctionsDir\Get-Configs.ps1")) {
    @'
    function Get-Configs {
        Write-Host "Configuration exporter loaded." -ForegroundColor Cyan
    }
'@ | Out-File -FilePath "$FunctionsDir\Get-Configs.ps1" -Encoding utf8 -Force
}

# ---------------------------------------------------------------------------
# 3. Create Master Loader Script
# ---------------------------------------------------------------------------
Write-Host "[3/6] Generating CustomFunctions.ps1 loader..." -ForegroundColor Cyan
@'
# Automatically load all script files in the Functions folder
Get-ChildItem -Path "$PSScriptRoot\Functions\*.ps1" | ForEach-Object {
    . $_.FullName
}
'@ | Out-File -FilePath "$ScriptsDir\CustomFunctions.ps1" -Encoding utf8 -Force

# ---------------------------------------------------------------------------
# 4. Configure WSL2 Settings
# ---------------------------------------------------------------------------
Write-Host "[4/6] Creating .wslconfig configuration..." -ForegroundColor Cyan
$WslConfigContent = @'
[wsl2]
memory=8GB
processors=4
localhostForwarding=true
'@

$WslConfigContent | Out-File -FilePath "$ScriptsDir\.wslconfig" -Encoding utf8 -Force
$WslConfigContent | Out-File -FilePath "$HOME\.wslconfig" -Encoding utf8 -Force

# ---------------------------------------------------------------------------
# 5. Link Master Loader to PowerShell Profile
# ---------------------------------------------------------------------------
Write-Host "[5/6] Linking loader to active $PROFILE..." -ForegroundColor Cyan
if (!(Test-Path $PROFILE)) {
    New-Item -Type File -Path $PROFILE -Force | Out-Null
}

$ProfileLine = ". `"$ScriptsDir\CustomFunctions.ps1`""
$CurrentProfileContent = Get-Content -Path $PROFILE -ErrorAction SilentlyContinue

if ($CurrentProfileContent -notcontains $ProfileLine) {
    Add-Content -Path $PROFILE -Value "`n$ProfileLine"
}

# ---------------------------------------------------------------------------
# 6. Initialize Git & Make First Commit
# ---------------------------------------------------------------------------
Write-Host "[6/6] Setting up Git repository and credentials..." -ForegroundColor Cyan
git config --global user.name $GitName
git config --global user.email $GitEmail

Set-Location $ScriptsDir
if (!(Test-Path "$ScriptsDir\.git")) {
    git init
}

git add .
git commit -m "Initial commit: PowerShell environment, functions, and WSL2 setup"

Write-Host "`n=== Setup Complete! Reloading Profile... ===" -ForegroundColor Green
. $PROFILE


