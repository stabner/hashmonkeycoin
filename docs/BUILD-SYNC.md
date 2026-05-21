# Keeping HMNY source and binaries in sync

## Single source of truth

| Path | Role |
|------|------|
| `D:\My_Blockchain\hashmonkey-core\` | Edit code here (git repo) |
| NAS `.../src/hashmonkey-gui/monero/` | **Build tree** used by `hashmonkey-gui` (must match core) |
| NAS `.../release-packages/` | Latest Linux + Windows outputs + `manifest-latest.txt` |
| Desktop `HMNY_monero_fork\` | Public release copy (`linux/bin`, `windows/bin`, `SHA256SUMS.txt`) |

## One-command sync on NAS

After pushing/copying changes into `hashmonkey-core` on the NAS:

```bash
# From Windows: upload changed files to /tmp/hmny-sync/ then:
ssh monkeynas@192.168.1.211 'bash /home/monkeynas/hashmonkey/scripts/hmny-apply-sync-on-nas.sh'
ssh monkeynas@192.168.1.211 'bash /home/monkeynas/hashmonkey/scripts/hmny-sync-build-nas.sh'
```

Or copy from PC with `scripts/hmny-apply-sync-on-nas.sh` via `/tmp/hmny-sync` (see session workflow).

## Verify versions match

```bash
sha256sum /home/monkeynas/hashmonkey/release-packages/linux/hashmonkeyd
# compare to Desktop HMNY_monero_fork/linux/bin/hashmonkeyd
```

Manifest: `release-packages/manifest-latest.txt` on NAS = `SHA256SUMS.txt` on Desktop.

## Mainnet / testnet policy

See [MAINNET-SECURITY.md](MAINNET-SECURITY.md).
