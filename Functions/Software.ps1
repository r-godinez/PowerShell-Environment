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
        Write-Host "`n[+] Installing: $id" -ForegroundColor Cyan
        winget install --id $id --exact --accept-package-agreements --accept-source-agreements
    }
}
