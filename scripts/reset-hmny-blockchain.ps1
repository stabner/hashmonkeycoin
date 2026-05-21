# Stop HMNY daemon/GUI, delete local blockchain + wallet scan state for a fresh start.
# Does NOT delete wallet keys in Documents — only daemon chain data under AppData.

$ErrorActionPreference = "Stop"
$dataDir = Join-Path $env:APPDATA "hashmonkeycoin"

Write-Host "Stopping hashmonkeyd / hashmonkey-wallet-gui if running..."
Get-Process hashmonkeyd, hashmonkey-wallet-gui -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

if (Test-Path $dataDir) {
    Write-Host "Removing blockchain data: $dataDir"
    Remove-Item -Recurse -Force $dataDir
} else {
    Write-Host "No data dir at $dataDir (already clean)."
}

Write-Host ""
Write-Host "Done. Next steps:"
Write-Host "  1. Settings > Info: set Wallet restore height to 0 (existing wallets)"
Write-Host "  2. Start hashmonkeyd with --start-mining YOUR_ADDRESS"
Write-Host "  3. Or use GUI Mining tab after daemon is running"
