function Update-Apps {
    [CmdletBinding()]
    param(
        [switch]$IncludeUnknown,
        [switch]$IncludePinned
    )

    Write-Host "`n[+] Checking for software updates via Winget..." -ForegroundColor Cyan

    $wingetArgs = @("upgrade", "--all", "--accept-package-agreements", "--accept-source-agreements")

    if ($IncludeUnknown) {
        $wingetArgs += "--include-unknown"
    }

    if ($IncludePinned) {
        $wingetArgs += "--include-pinned"
    }

    winget @wingetArgs
}
