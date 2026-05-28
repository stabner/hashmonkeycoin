# HashmonkeyCoin testnet — setup guide

Public testnet only. In the wallet wizard, **always choose Testnet** until mainnet is announced.

| | |
|--|--|
| **Download** | **[v0.2.5-testnet](https://github.com/stabner/hashmonkeycoin/releases/tag/v0.2.5-testnet)** (latest) · [all releases](https://github.com/stabner/hashmonkeycoin/releases) |
| **Seed (P2P)** | `seednode.hashmonkeys.cloud:48080` |
| **Seed (wallet RPC)** | `seednode.hashmonkeys.cloud:48081` |
| **Explorer** | https://explorer.hashmonkeys.cloud (HashmonkeyCoin testnet) |

Verify downloads with **`SHA256SUMS.txt`** on the release page.

### What’s new in v0.2.5-testnet

- **GUI branding:** welcome screen and processing splash use the same **`hmny-splash`** artwork (`wallet4_black_back` source).
- **Password dialog:** restored blurred/dimmed background on Windows (wizard text no longer shows through the password prompt).
- **Windows data paths** documented below — the wallet does **not** store the blockchain next to the `.exe` by default.
- **Daemon unchanged** from v0.2.4 for consensus; GUI-only upgrade — you usually **do not** need to delete testnet chain data when updating from v0.2.4-testnet.

---

## Who should read which section

| You want to… | Start here |
|--------------|------------|
| Use the wallet on Windows or Linux | [Easiest path](#easiest-path--wallet-only-recommended-for-new-users) or [Full node](#full-node-path-download-the-chain-on-your-pc) |
| Mine on a pool | [Mining on the pool](#mining-on-the-pool) |
| Run a public seed | [Seed operator checklist](#seed-operator-checklist) |
| Understand hardforks | [Hardfork schedule (HMNY)](#hardfork-schedule-hmny) |
| Compile from source | [Build from source](#build-from-source) |

---

## Hardfork schedule (HMNY)

HashmonkeyCoin uses **hard forks** (consensus rule changes at defined block heights), inherited from Monero’s design. HMNY’s schedule is **not** the old Monero calendar table in `hashmonkey-core/README.md` (2016–2022 heights) — that section is upstream history only.

**Source of truth:** `hashmonkey-core/src/hardforks/hardforks.cpp` — **testnet and mainnet use the same heights.**

| Block height | Version | Notes |
|--------------|---------|--------|
| 1–11 | v1–v11 | Rule steps on a **new** chain (first blocks after genesis) |
| **12** | **v12** | **RandomX** mining |
| 13–16 | v13–v16 | CLSAG, format bans, ring size 16, bulletproofs+, view tags |

There is **no extra public “fork day”** on a future calendar date unless the project **changes** `hardforks.cpp` and ships a new release. For normal testing: run the **latest testnet binaries** and stay on **Testnet** in the wallet.

**When you must wipe testnet chain data**

- After a **consensus / hardfork schedule** change announced with a new release.
- If you see **`Unexpected hard fork version v2 at height 2`** or similar — old chain data or old binaries; install the latest release, delete the testnet chain folder (below), resync from the seed.

**When you usually do not wipe**

- GUI-only or wallet-only updates if the release notes say the daemon and consensus are unchanged.

More detail: **hashmonkey-core/README-HMNY.md**.

---

## Before you start (upgrading from an older testnet build)

If the release notes mention a **hardfork or consensus change**, or you hit fork errors, follow [Hardfork schedule (HMNY)](#hardfork-schedule-hmny) and delete the testnet chain folder below. Very old blockchain folders will not sync on the current network.

1. Close the wallet and daemon (`hashmonkey-wallet-gui`, `hashmonkeyd`).
2. Delete **only** the testnet **chain** folder (wallet files are usually stored separately):
   - **Windows:** Win+R → `%ProgramData%\hashmonkeycoin\testnet` → delete contents.
   - **Linux:** delete `~/.hashmonkeycoin/testnet/`
3. Install binaries from the **latest** testnet release and continue below.

You do **not** need to delete the chain folder when only replacing the **GUI** `.exe` and the release notes say the daemon is unchanged.

---

## Easiest path — wallet only (recommended for new users)

No manual daemon. No full blockchain download on your PC.

1. Download **`hmny-testnet-windows-x64.zip`** (Windows) or **`hmny-testnet-linux-x64.tar.gz`** (Linux) from [Releases](https://github.com/stabner/hashmonkeycoin/releases).
2. Extract the archive.
3. Open the wallet folder inside the zip:
   - **Windows:** `windows\wallet-gui\`
   - **Linux:** `ubuntu\wallet-gui\` if present, otherwise follow the short **README** inside the tarball.
4. Run **`hashmonkey-wallet-gui`** (`.exe` on Windows).
5. In the wizard:
   - **Language** — your choice
   - **Network** — **Testnet**
   - Mode — **Testnet — quick start (recommended)**
   - Create a wallet (use restore height **0** for a brand-new wallet)
6. Wait until the status bar shows **connected** / synchronized (a few minutes is normal).

The wallet connects to the public seed RPC: **`seednode.hashmonkeys.cloud:48081`**.

### Windows security prompt

Unsigned wallets often trigger **SmartScreen** or antivirus warnings. That is common for community-built privacy software.

1. Compare your file hash to **`SHA256SUMS.txt`** on the release page.
2. If it matches, choose **More info** → **Run anyway** (SmartScreen), or restore the file from quarantine after verifying the hash.

---

## Full node path (download the chain on your PC)

Use this for your own `hashmonkeyd`, local mining, or maximum privacy.

1. Extract the release archive.
2. Put **`hashmonkeyd`** and **`hashmonkey-wallet-gui`** in the **same** folder (`windows\wallet-gui` on Windows).
3. Run **`hashmonkey-wallet-gui`**.
4. Wizard: **Testnet** → **Testnet — full node**.
5. Leave **Start a node automatically** enabled unless you plan to start the daemon yourself.
6. Wait until status shows **Synchronized** (first sync can take a while).

The GUI starts the daemon with public peers. Your wallet talks to **`127.0.0.1:48081`** on your computer.

### Windows — start the daemon manually (optional)

Open a terminal in `windows\wallet-gui`:

```powershell
.\hashmonkeyd.exe --testnet --check-updates=disabled
```

If your build does not already include the public seed, add:

```powershell
.\hashmonkeyd.exe --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
```

In the daemon window, type **`status`**. You want **testnet**, a growing **height**, and **`(Nout) ≥ 1`**.

**Chain data:** `%ProgramData%\hashmonkeycoin\testnet\`

### Linux — start the daemon manually (optional)

```bash
tar -xzf hmny-testnet-linux-x64.tar.gz
cd ubuntu
chmod +x run-hashmonkeyd.sh daemon/hashmonkeyd
./run-hashmonkeyd.sh --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
```

**Chain data:** `~/.hashmonkeycoin/testnet/`

---

## Where the wallet stores data (Windows)

The **`windows\wallet-gui`** folder in the release zip contains only **`hashmonkey-wallet-gui.exe`** and **`hashmonkeyd.exe`**. A `blockchain` folder is **not** created there unless you set a custom path in **Settings → Node**.

| Data | Default location |
|------|------------------|
| **Blockchain (local daemon)** | `%ProgramData%\hashmonkeycoin\` (testnet: `...\testnet\lmdb\`) |
| **Wallets (new installs)** | `%USERPROFILE%\Documents\HashmonkeyCoin\wallets\` |
| **GUI settings** | Registry `HKCU\Software\hashmonkeycoin\hashmonkey-core` |
| **GUI log** | `%AppData%\hashmonkey-wallet-gui\hashmonkey-wallet-gui.log` |

**Quick start (remote node):** the GUI often uses **`seednode.hashmonkeys.cloud:48081`** and may not download a full chain locally.

**Reset testnet chain + GUI settings (Windows):** close the wallet, delete `%ProgramData%\hashmonkeycoin\testnet`, and remove the `hashmonkeycoin` key under `HKCU\Software` if you want a completely fresh wizard (wallet `.keys` files in Documents are separate — back them up first).

Legacy **Monero** paths (`Documents\Monero`, `%ProgramData%\bitmonero`) are from upstream Monero GUI testing and are **not** used by a clean HMNY v0.2.5 install.

---

## Ports (do not mix these up)

| Port | Purpose | Wallet GUI? |
|------|---------|-------------|
| **48080** | P2P between daemons | **No** |
| **48081** | RPC (wallet ↔ daemon) | **Yes** |

- Local wallet with your own daemon: **`127.0.0.1:48081`**
- Remote wallet (quick start): **`seednode.hashmonkeys.cloud:48081`**

---

## Mining on the pool

1. Use a **testnet** address from the wallet **Receive** page.
2. Point your miner at the pool host and port listed on [HashMonkeys.cloud](https://hashmonkeys.cloud) for HMNY testnet.
3. Pool **“Total paid”** means the pool sent a payout. Your wallet balance updates after the transaction is in a block and matures (~**10 blocks**, ~20 minutes at ~2 min/block).

Check **History** in the GUI. If the pool provides a transaction ID, you can look it up on the explorer.

### When are testnet coins spendable?

| How you got coins | Shows in wallet | Spendable (can send) |
|-------------------|-----------------|----------------------|
| **Pool payout** | ~1 block after confirmation | ~**10 blocks** later |
| **Mined block reward** | ~1 block | ~**60 blocks** later (~2 hours) |

Testnet coins have **no real-world value**.

---

## Seed operator checklist

Remote users connect **outbound** to **`seednode.hashmonkeys.cloud`**. They do not need a private LAN address from the operator.

1. **Firewall / router:** forward **TCP 48080** (P2P) and **TCP 48081** (RPC) to the machine running the seed.
2. **DNS:** `seednode.hashmonkeys.cloud` → public IPv4 (A record) of that machine.
3. **Daemon:** run testnet with **`--public-node`**, **`--check-updates=disabled`**, and **restricted RPC** on port **48081** (do not expose unrestricted RPC to the internet).
4. **Verify from outside your network:** port **48080** and **48081** must be reachable (online port checker or `Test-NetConnection seednode.hashmonkeys.cloud -Port 48080` from another network).

Example start (adjust paths to your install):

```bash
hashmonkeyd --testnet --check-updates=disabled --public-node \
  --rpc-restricted-bind-port=48081 --rpc-restricted-bind-ip=0.0.0.0 \
  --confirm-external-bind --add-peer seednode.hashmonkeys.cloud:48080
```

---

## Troubleshooting

| Problem | What to do |
|---------|------------|
| Wallet **disconnected** | Network = **Testnet**. Quick start: `seednode.hashmonkeys.cloud:48081`. Full node: start `hashmonkeyd --testnet`, node = `127.0.0.1:48081`. |
| Used port **48080** in the wallet | Wrong port — the wallet uses **48081**. |
| Balance **0** after pool “paid” | Open **History**; wait for confirmation + ~10 blocks; stay **connected** and **synced**. |
| Height **0** / no sync | Daemon needs `--testnet` and peers; in `status`, check **`(Nout) ≥ 1`**. |
| **`Unexpected hard fork version v2 at height 2`** | Old wallet or old chain data. Install the **latest testnet release**, delete the testnet chain folder (see top), set **Testnet**, reconnect. New restore height: **0**. |
| Explorer shows **no peers** | Normal on a public RPC view — P2P may be hidden. Check your own daemon `status` / `print_cn`. |
| **`(Min)` is 0** on home daemon | Normal without port forwarding; outbound sync can still work. |
| Sync fails on same LAN as seed | Public hostname may not work from inside the same network (router “hairpin NAT”). Try another network (e.g. mobile data) or a LAN peer address supplied by the operator. |
| Linux `libboost` missing (release zip) | Use **`./run-hashmonkeyd.sh`** from the `ubuntu/` folder (bundled libraries). |
| Linux **build** fails at `cmake` | Install the full dependency table under [Build from source](#build-from-source). |
| Wrong chain / odd heights | Delete testnet chain folder (see top), re-sync with the latest release. |
| Build: **`monero/crypto/amd64-64-24k.h: No such file`** | Run `git submodule update --init --recursive` in `hashmonkey-core`, or `cmake -DMONERO_WALLET_CRYPTO_LIBRARY=cn -B build`. |
| Windows **virus / SmartScreen** on `.exe` | Verify **`SHA256SUMS.txt`**. False positives are common for unsigned wallets; restore from quarantine only after the hash matches. |

---

## Build from source

**Recommended for almost everyone:** use **[GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases)**. No compiler required.

Building is for **developers** and **packagers**. Expect **30–90+ minutes** and several GB of disk space for a full core build.

### Supported platforms

| Platform | Core (daemon + CLI) | Desktop GUI |
|----------|---------------------|-------------|
| **Linux** (Ubuntu 22.04 / Debian 12 class) | Supported — full steps below | Supported — needs Qt 5 (below) |
| **Windows** | Advanced (MSYS2 / depends) | **Use the release static `.exe`**; local builds need the Monero **depends** toolchain |
| **macOS** | Upstream Monero docs apply | Not covered here |

### Step 1 — Clone with submodules

```bash
git clone --recursive https://github.com/stabner/hashmonkeycoin.git
cd hashmonkeycoin/hashmonkey-core
git submodule update --init --recursive
```

### Step 2 — Linux dependencies (daemon + CLI)

**Required** (CMake will fail without these):

| Package | Purpose |
|---------|---------|
| `build-essential` | gcc/g++, make |
| `cmake` | Build system |
| `git` | Submodules |
| `pkg-config` | Find libraries |
| `libboost-all-dev` | Boost (≥ 1.66) |
| `libssl-dev` | OpenSSL |
| `libsodium-dev` | Crypto |
| `libunbound-dev` | DNS |
| `libzmq3-dev` | ZMQ |

**Recommended:** `libreadline-dev` `libunwind-dev` `liblzma-dev` `libexpat1-dev` `libhidapi-dev` `libusb-1.0-0-dev` `libprotobuf-dev` `protobuf-compiler` `libudev-dev`

**Ubuntu / Debian one-shot:**

```bash
sudo apt update
sudo apt install -y build-essential cmake git pkg-config curl \
  libboost-all-dev libssl-dev libsodium-dev libunbound-dev libzmq3-dev \
  libreadline-dev libunwind-dev liblzma-dev libexpat1-dev \
  libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev
```

**Build core:**

```bash
cd hashmonkeycoin/hashmonkey-core
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
```

Outputs (typical): `build/release/bin/hashmonkeyd`, `hashmonkey-wallet-cli`, `hashmonkey-wallet-rpc`.

More detail: **hashmonkey-core/README-HMNY.md**.

### Step 3 — Desktop GUI (Linux)

Install **Qt 5** (≥ 5.12):

```bash
sudo apt install -y qtbase5-dev qtdeclarative5-dev qttools5-dev qttools5-dev-tools \
  qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qt-labs-platform \
  libqt5svg5-dev libqt5xmlpatterns5-dev libqt5quickcontrols2-5
```

Build **core first**, then wire the core tree into `hashmonkey-gui` per upstream Monero GUI layout and compile:

```bash
cd hashmonkeycoin/hashmonkey-gui
mkdir -p build/release && cd build/release
cmake -DCMAKE_BUILD_TYPE=Release -DWITH_UPDATER=OFF ../..
make -j"$(nproc)" hashmonkey-wallet-gui
```

Ship **`hashmonkeyd`** next to the GUI for full-node mode. Full GUI notes: **hashmonkey-gui/README-HMNY.md**.

### Step 4 — Windows GUI (packagers only)

Testnet users should download **`hashmonkey-wallet-gui.exe`** from Releases (static build, no extra DLLs).

Packagers: build with the same **depends / cross-compile** approach as [monero-gui](https://github.com/monero-project/monero-gui) (`STATIC=ON`, MinGW toolchain). That pipeline is not duplicated here; follow upstream Windows instructions using this repository’s sources.

### Common build failures

| Error | Fix |
|-------|-----|
| `Could NOT find Sodium` / `Unbound` / `libzmq` | Install `libsodium-dev`, `libunbound-dev`, `libzmq3-dev`. |
| `monero/crypto/amd64-64-24k.h: No such file` | `git submodule update --init --recursive`, or `-DMONERO_WALLET_CRYPTO_LIBRARY=cn`. |
| `Could NOT find Boost` | `sudo apt install libboost-all-dev` |
| Build killed / OOM | `cmake --build build -j2` |

---

## Quick reference

**Wallet only:** GUI → **Testnet** → **Quick start** → create wallet.

**Full node (Windows):**

```powershell
cd windows\wallet-gui
.\hashmonkeyd.exe --testnet --check-updates=disabled
.\hashmonkey-wallet-gui.exe
```

**Full node (Linux):**

```bash
cd ubuntu
./run-hashmonkeyd.sh --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
```

**RPC:** local `127.0.0.1:48081` · remote `seednode.hashmonkeys.cloud:48081` · **Network:** Testnet

**Help:** [GitHub Issues](https://github.com/stabner/hashmonkeycoin/issues)
