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
