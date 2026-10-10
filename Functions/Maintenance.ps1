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
