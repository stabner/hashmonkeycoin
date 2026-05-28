# HashmonkeyCoin GUI (`hashmonkey-gui`)

Desktop wallet for **HashmonkeyCoin (HMNY)** — forked from [monero-gui](https://github.com/monero-project/monero-gui).

## For most users

Download the testnet release (**`hmny-testnet-windows-x64.zip`** or Linux tarball) and follow **[TESTNET-GUIDE.md](../TESTNET-GUIDE.md)**. You do not need to compile the GUI.

## Fork attribution

**Copyright (c) The Monero Project** remains in source files and `LICENSE`. Do not remove upstream copyright headers.

- Repository: [github.com/stabner/hashmonkeycoin](https://github.com/stabner/hashmonkeycoin)
- Testnet guide: [TESTNET-GUIDE.md](../TESTNET-GUIDE.md)

## Build from source (developers)

### 1. Build core first

Install dependencies and build **`hashmonkey-core`** as described in **[TESTNET-GUIDE.md](../TESTNET-GUIDE.md)** (Linux) or **hashmonkey-core/README-HMNY.md**.

You need a built `hashmonkeyd` and linked libraries before the GUI will compile.

### 2. Link core into the GUI tree

From the repository root, copy or symlink your built core into the GUI tree (same layout as upstream Monero GUI):

- `hashmonkey-gui/hashmonkey-core/` — HMNY core sources (or build output tree per upstream CMake docs)
- `hashmonkey-gui/monero/` — often a second copy/symlink expected by legacy CMake paths

Follow the upstream **monero-gui** `README.md` in this folder for the exact `monero` / `hashmonkey-core` layout your CMake version expects.

### 3. Linux GUI dependencies (Qt 5)

On Ubuntu/Debian (22.04 or similar):

```bash
sudo apt install -y qtbase5-dev qtdeclarative5-dev qttools5-dev qttools5-dev-tools \
  qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qt-labs-platform \
  libqt5svg5-dev libqt5xmlpatterns5-dev libqt5quickcontrols2-5
```

### 4. Compile the GUI (Linux example)

```bash
cd hashmonkey-gui
mkdir -p build/release && cd build/release
cmake -DCMAKE_BUILD_TYPE=Release -DWITH_UPDATER=OFF ../..
make -j"$(nproc)" hashmonkey-wallet-gui
```

Binary: `build/release/bin/hashmonkey-wallet-gui` (path may vary slightly by generator).

Place **`hashmonkeyd`** in the same folder as the GUI for **full-node** mode.

### 5. Windows GUI builds

Building on Windows is **advanced** (MSYS2/MinGW with Monero **depends**, or a container toolchain). **Testnet users should use the static GUI from [GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases)** instead of compiling locally.

### Brand images

Release builds use HMNY artwork under `hashmonkey-gui/images/` (for example `hmny-hero.png`, `hmny-titlebar-128.png`). Rebuild QML resources after changing PNGs (`qml.qrc`).

## Rebrand notes

- User-visible strings use HMNY / HashmonkeyCoin in QML and C++ `tr()` sources where updated.
- Internal QML import `moneroComponents` is unchanged (not shown to end users).
- Files under `translations/` may still say “Monero” until refreshed with Qt `lupdate` / `lrelease`.

## Upstream documentation

[README.md](README.md) in this directory is the original **Monero GUI** readme. Use it for generic Qt and translation workflow; HMNY testnet usage is in the root **TESTNET-GUIDE.md**.
