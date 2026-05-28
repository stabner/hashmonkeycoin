# Maintainer notes (public)

This repository contains **source code** and user documentation. **Pre-built binaries** are published on GitHub Releases, not stored in git.

## Layout

| Path | Contents |
|------|----------|
| `hashmonkey-core/` | Daemon and wallets — clone **with submodules** |
| `hashmonkey-gui/` | Desktop wallet GUI |
| `TESTNET-GUIDE.md` | End-user testnet setup and build reference |
| `contrib/` | Maintainer hints |

## Releases

- **Tags:** `v0.2.x-testnet` (increment for each public testnet drop)
- **Artifacts:** `hmny-testnet-windows-x64.zip`, `hmny-testnet-linux-x64.tar.gz`, `SHA256SUMS.txt`
- **Publish:** [GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases)

A typical Windows bundle includes `hashmonkey-wallet-gui`, `hashmonkeyd`, CLI, and RPC in `windows/wallet-gui` (Linux layout may use `ubuntu/` — see the zip README inside the release).

## Build from source (summary)

Full steps: **TESTNET-GUIDE.md** (Linux deps + core) and **hashmonkey-gui/README-HMNY.md** (Qt GUI).

```bash
git clone --recursive https://github.com/stabner/hashmonkeycoin.git
cd hashmonkeycoin/hashmonkey-core
git submodule update --init --recursive
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
```

Then build `hashmonkey-gui` after core is available to the GUI CMake tree.

**Windows GUI:** ship a **static** `hashmonkey-wallet-gui.exe` built with the Monero **depends** toolchain (same class of build as upstream Monero Windows releases). Most users should download the release binary rather than building locally.

## Public testnet infrastructure

| Service | Address |
|---------|---------|
| Seed P2P | `seednode.hashmonkeys.cloud:48080` |
| Seed RPC | `seednode.hashmonkeys.cloud:48081` |
| Explorer | https://explorer.hashmonkeys.cloud |

Seed operators: forward TCP **48080** (P2P) and **48081** (RPC), run `hashmonkeyd --testnet --public-node` with restricted RPC, point DNS A record for `seednode.hashmonkeys.cloud` at the host’s public IP. Details in **TESTNET-GUIDE.md** (seed operator section).

## Before tagging a new testnet release

1. Confirm GUI branding assets in `hashmonkey-gui/images/` and QML match what you intend to ship.
2. Rebuild **core + GUI** (release build machine or CI) and refresh all binaries in the zip/tarball.
3. Generate `SHA256SUMS.txt`.
4. Update **TESTNET-GUIDE.md** / **README.md** / **hashmonkey-core/README-HMNY.md** if the tag includes a **hardfork schedule** change (`src/hardforks/hardforks.cpp`); announce testnet chain reset when required.
5. Restart the public seed with the new `hashmonkeyd` when daemon behavior or P2P defaults change.
