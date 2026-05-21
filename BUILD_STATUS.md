# HashmonkeyCoin (HMNY) — Build Status

Last updated: 2026-05-20

## Completed on `monkeynas@192.168.1.211`

| Component | Status | Path |
|-----------|--------|------|
| Core (`hashmonkeyd`, wallets) | Built | `~/hashmonkey/src/hashmonkey-core/build/Linux/master/release/bin/` |
| GUI (`hashmonkey-wallet-gui`) | Built | `~/hashmonkey/src/hashmonkey-gui/build/release/bin/` |
| Mainnet genesis | `d338b3caa6c110978eb2200eb4de398ada9f50bfa01c0c120c36817b22eabf15` | height 1 verified |
| Build tools (Ubuntu 22.04) | Installed | gcc, cmake, Boost, Qt 5.15, libsodium, etc. |

## Network parameters

| | Mainnet | Testnet |
|--|---------|---------|
| P2P | 28080 | 48080 |
| RPC | 28081 | 48081 |
| ZMQ | 28082 | 48082 |
| Address prefix | 48 / 49 / 50 | 53 / 54 / 63 |

## Windows workspace (`D:\My_Blockchain`)

- Patched sources synced: `hashmonkey-core/`, `hashmonkey-gui/`, `hashmonkey-gui/hashmonkey-core/`
- Patch scripts: `scripts/patch1.py` … `patch5.py`, `patch_gui.py`, `patch_testnet.py`, `patch_qml_colors.py`
- Example config: `scripts/hashmonkeycoin.conf.example`

## Not done / blocked

- **`hashserver@192.168.1.50`**: SSH auth failed; use monkeynas or fix keys
- **Custom logos**: `logo/` is empty — GUI still uses upstream Monero vector art
- **Windows `.exe`**: not built (needs MSYS2 or cross-compile)
- **Seed nodes**: mainnet seed list cleared; add peers when deploying
- **Blockchain utilities**: built as `hashmonkey-blockchain-*` / `hashmonkey-gen-*`

## Run daemon (mainnet, monkeynas)

```bash
hashmonkeyd --config-file /tmp/hmny-empty.conf
# Or use Monero-format ~/.hashmonkeycoin/hashmonkeycoin.conf (Dash-style conf was replaced)
```

## Run GUI (monkeynas, headless / X11)

```bash
~/hashmonkey/src/hashmonkey-gui/build/release/bin/hashmonkey-wallet-gui
```
