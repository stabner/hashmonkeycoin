# Release v0.2.5-testnet

## Summary

HMNY testnet GUI refresh: splash/welcome branding, Windows password-dialog overlay fix. Daemon/consensus unchanged from v0.2.4-testnet.

## Assets

- `hmny-testnet-windows-x64.zip` — `windows/wallet-gui/hashmonkey-wallet-gui.exe` + `hashmonkeyd.exe`
- `hmny-testnet-linux-x64.tar.gz` — `ubuntu/` layout per package script
- `SHA256SUMS.txt`

## Release notes (GitHub)

- GUI: **hmny-splash** branding on wizard welcome and processing splash (`logo/wallet4_black_back.png`).
- GUI: password prompt dim/blur restored on Windows.
- Docs: **TESTNET-GUIDE.md** — v0.2.5, Windows data locations.
- Upgrade from v0.2.4: replace GUI `.exe` only; no chain wipe required unless release notes say otherwise.

## Packager commands (NAS)

Build Windows GUI + daemon (static), package zips, publish:

```bash
# On NAS after git pull / upload sources
bash /home/monkeynas/hashmonkey/scripts/hmny-nas-static-gui-build.sh
# Then package on Windows maintainer machine from release-packages/
```

```powershell
# After pulling release-packages from NAS or local build:
powershell -File scripts\hmny-package-release.ps1
powershell -File scripts\create-github-release.ps1 -Tag v0.2.5-testnet
```
