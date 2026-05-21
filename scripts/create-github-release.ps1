# Create GitHub release v0.2.0 with Windows/Linux binary zips (requires: gh auth login)
param(
    [string]$Tag = "v0.2.0",
    [string]$PackagesDir = "D:\My_Blockchain\release-packages"
)

$gh = @(
    "$env:ProgramFiles\GitHub CLI\gh.exe",
    "$env:LocalAppData\Programs\GitHub CLI\gh.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $gh) {
    Write-Error "Install GitHub CLI: winget install GitHub.cli — then run: gh auth login"
}

$win = Join-Path $PackagesDir "hmny-windows-x64.zip"
$linux = Join-Path $PackagesDir "hmny-linux-x64.zip"
foreach ($f in @($win, $linux)) {
    if (-not (Test-Path $f)) { Write-Error "Missing package: $f" }
}

$body = @"
## HMNY v0.2.0

- **hashmonkey-core** / **hashmonkey-gui** (renamed from monero trees)
- Windows static GUI + daemon + blockchain tools (`hashmonkey-*`)
- Linux x64 binaries (Ubuntu 22.04+ compatible)

### Install

| Platform | Archive | Run |
|----------|---------|-----|
| Windows | ``hmny-windows-x64.zip`` | ``windows\wallet-gui\hashmonkey-wallet-gui.exe`` |
| Linux | ``hmny-linux-x64.zip`` | ``ubuntu/wallet-gui/hashmonkey-wallet-gui`` (``chmod +x`` first) |

Testnet RPC example: ``192.168.1.211:48081`` (empty bootstrap URL in GUI).
"@

& $gh release create $Tag $win $linux --title "HMNY v0.2.0" --notes $body
Write-Host "Release created for tag $Tag"
