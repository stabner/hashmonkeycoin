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

### 2. Prepare the GUI build tree

The GUI CMake project expects core sources at **`hashmonkey-gui/hashmonkey-core/`** (gitignored copy of top-level **`hashmonkey-core/`**).

From the repository root:

```bash
bash contrib/prepare-gui-build.sh
```

This rsyncs `hashmonkey-core/` → `hashmonkey-gui/hashmonkey-core/`. Re-run after every core change.

**Do not use** a legacy `hashmonkey-gui/monero/` folder — it was removed from the HMNY build layout.

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
cmake -DCMAKE_BUILD_TYPE=Release -DMANUAL_SUBMODULES=1 -DWITH_UPDATER=OFF ../..
make -j"$(nproc)" hashmonkey-wallet-gui
```

Binary: `build/release/bin/hashmonkey-wallet-gui` (path may vary slightly by generator).

Place **`hashmonkeyd`** in the same folder as the GUI for **full-node** mode.

### 5. Windows GUI builds

Building on Windows is **advanced** (MSYS2/MinGW with Monero **depends**, or a container toolchain). **Testnet users should use the static GUI from [GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases)** instead of compiling locally.

### Brand images

Release builds use HMNY artwork under `hashmonkey-gui/images/` (`hmny-splash.png`, `hmny-titlebar-128.png`, etc.). Regenerate from `logo/` with `python scripts/apply_hmny_brand.py` (maintainer script), then rebuild QML resources.

## Rebrand notes

- User-visible strings use HMNY / HashmonkeyCoin in QML and C++ where updated.
- Settings: **`HmnySettings`** / registry org **`hashmonkeycoin`**; config file **`hashmonkey-core.conf`** (Tails portable path).
- GUI translations: **`translations/hmny-core_*.ts`** (was `monero-core_*`).
- Internal QML import alias **`MoneroComponents`** remains (not shown to users; optional future rename).
- **`hashmonkey-core/translations/monero_*.ts`** — CLI wallet locales; upstream filenames kept for compatibility.

## Upstream documentation

[README.md](README.md) in this directory is the original **Monero GUI** readme. Use it for generic Qt and translation workflow; HMNY testnet usage is in the root **TESTNET-GUIDE.md**.
