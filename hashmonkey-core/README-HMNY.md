# HashmonkeyCoin core (`hashmonkey-core`)

**HashmonkeyCoin (HMNY)** is a privacy-focused cryptocurrency fork based on [Monero](https://www.getmonero.org/). This directory contains `hashmonkeyd`, wallet tools, and blockchain utilities.

## For most users

Use prebuilt binaries from **[GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases)** and **[TESTNET-GUIDE.md](../TESTNET-GUIDE.md)**. Compiling from source is optional.

## Fork attribution

This software is derived from the Monero Project. **Copyright notices in source files and `LICENSE` must remain intact** per the Monero BSD license.

- Upstream: [monero-project/monero](https://github.com/monero-project/monero)
- HMNY repository: [github.com/stabner/hashmonkeycoin](https://github.com/stabner/hashmonkeycoin)

## Build from source (Linux)

Install the **full** dependency set in **[TESTNET-GUIDE.md](../TESTNET-GUIDE.md)** (`libsodium-dev`, `libunbound-dev`, `libzmq3-dev`, Boost, OpenSSL, and related packages). A one-line `apt` install without those libraries will fail on a clean system.

```bash
git clone --recursive https://github.com/stabner/hashmonkeycoin.git
cd hashmonkeycoin/hashmonkey-core
git submodule update --init --recursive
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
```

Typical outputs: `build/release/bin/hashmonkeyd`, `hashmonkey-wallet-cli`, `hashmonkey-wallet-rpc` (exact path depends on your CMake generator).

### Common fixes

| Problem | Action |
|---------|--------|
| Missing `amd64-64-24k.h` | Run `git submodule update --init --recursive`, or configure with `-DMONERO_WALLET_CRYPTO_LIBRARY=cn` |
| Missing Sodium / Unbound / ZMQ | Install `libsodium-dev`, `libunbound-dev`, `libzmq3-dev` |
| Out of memory while linking | Lower parallelism: `cmake --build build -j2` |

## Network (HMNY)

| | Mainnet | Testnet |
|--|---------|---------|
| P2P | 28080 | 48080 |
| RPC | 28081 | 48081 |
| Public testnet seed (P2P) | — | `seednode.hashmonkeys.cloud:48080` |
| Public testnet seed (RPC) | — | `seednode.hashmonkeys.cloud:48081` |

- **Testnet** is for public testing (coins have no value).
- **Mainnet** is not launched yet; mining requires `--allow-mainnet-mining` until announced.

## Hardfork schedule (HMNY)

HMNY enables consensus upgrades through the same **hard fork** mechanism as Monero, but the **activation heights are not Monero’s calendar schedule**. They are defined in **`src/hardforks/hardforks.cpp`** for both **testnet** and **mainnet** (identical tables).

This is a **new chain** design: fork versions turn on at **low block heights** so the network quickly reaches modern rules (RingCT, bulletproofs, CLSAG, view tags, etc.) without replaying Monero’s multi-million-block history.

| Block height | Fork version | What changes (summary) |
|--------------|--------------|-------------------------|
| 1 | v1 | Base rules from genesis onward |
| 2 | v2 | Early consensus step (2-minute block target era) |
| 3–11 | v3–v11 | Progressive Monero-style rule steps through the first blocks |
| **12** | **v12** | **RandomX** proof-of-work (`RX_BLOCK_VERSION` = 12) |
| 13 | v13 | CLSAG transaction format |
| 14 | v14 | Disallow older MLSAG format |
| 15 | v15 | Ring size 16, bulletproofs+, view tags, dynamic block weight |
| 16 | v16 | Disallow older v14 transaction format |

**There is no separate “upcoming HMNY fork on calendar date X”** in this file. The heights above are fixed in code for the current chain. A **future** consensus change means editing `hardforks.cpp`, shipping a new release, and usually **resetting testnet** (or launching a new chain) so all nodes agree.

**Do not use** the big “Scheduled software/network upgrades” table in [README.md](README.md) in this folder — that documents **Monero mainnet history**, not HMNY.

### If you change the schedule (maintainers)

1. Edit `src/hardforks/hardforks.cpp` (keep `testnet_hard_forks` and `mainnet_hard_forks` in sync unless you intentionally diverge).
2. Rebuild and publish a new testnet release; announce a **chain reset** if existing testnet data would diverge.
3. Update **TESTNET-GUIDE.md** and this section if user-facing upgrade steps change.

### If sync fails after an old build

Wallets or chain data from **before** the current HMNY fork layout may show errors such as **`Unexpected hard fork version v2 at height 2`**. Fix: install the **latest testnet release**, delete only the testnet **chain** folder (not wallet keys), reconnect to `seednode.hashmonkeys.cloud`, and use restore height **0** for new wallets. See **TESTNET-GUIDE.md**.

## Run testnet daemon (example)

```bash
./build/release/bin/hashmonkeyd --testnet --check-updates=disabled \
  --add-peer seednode.hashmonkeys.cloud:48080
```

Chain data: `~/.hashmonkeycoin/testnet/` on Linux.

## Upstream documentation

[README.md](README.md) here is the original **Monero project README** (research, contributing to Monero). HMNY testnet steps for end users are in the root **TESTNET-GUIDE.md**.
