# Launch HMNY wallet GUI after building hashmonkey-gui (testnet is the default in this fork).
param(
    [string]$GuiDir = ""
)
if (-not $GuiDir) {
    $GuiDir = Read-Host "Path to folder containing hashmonkey-wallet-gui.exe and hashmonkeyd.exe"
}
$exe = Join-Path $GuiDir "hashmonkey-wallet-gui.exe"
if (-not (Test-Path $exe)) {
    Write-Error "Not found: $exe — build hashmonkey-gui first."
}
Start-Process -FilePath $exe -WorkingDirectory $GuiDir
