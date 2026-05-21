# HashmonkeyCoin testnet — user setup guide

Public testnet only. **Always use testnet** until mainnet is announced.

| Item | Value |
|------|--------|
| Download | [GitHub Release v0.2.1-testnet](https://github.com/stabner/hashmonkeycoin/releases/tag/v0.2.1-testnet) |
| Seed node | `155.4.209.124:48080` |
| P2P port | **48080** |
| RPC port | **48081** |
| Block explorer | https://explorer.hashmonkeys.cloud |

Verify downloads with `SHA256SUMS.txt` on the release page.

---

## Part 1 — Run a node (daemon)

The node (`hashmonkeyd`) stores the blockchain and talks to other peers. The wallet connects to it later.

### Windows

1. Download **`hmny-testnet-windows-x64.zip`** from the release page and extract it (e.g. to `Desktop\HMNY`).
2. Open **PowerShell** in the `windows` folder inside the extract.
3. **Easiest:** run the helper script:
   ```powershell
   .\start-hmny-testnet.ps1
   ```
   This starts the testnet daemon and optionally opens the GUI.
4. **Manual start** (same thing, step by step):
   ```powershell
   .\hashmonkeyd.exe --testnet --check-updates=disabled --add-peer 155.4.209.124:48080
   ```
5. Wait until you see **“You are now synchronized with the network”** (may take a minute on first sync).
6. In the daemon window, type **`status`** and press Enter. You should see **testnet**, a **height** number, and **outgoing connections** ≥ 1.

**Important:** Without `--testnet`, the daemon runs **mainnet** (wrong ports and chain). Always include `--testnet`.

**Data folder:** `C:\ProgramData\hashmonkeycoin\testnet\`

**Firewall:** allow `hashmonkeyd.exe` on private networks if Windows asks.

### Linux (Ubuntu 22.04+)

1. Download **`hmny-testnet-linux-x64.tar.gz`** and extract:
   ```bash
   tar -xzf hmny-testnet-linux-x64.tar.gz
   cd ubuntu/daemon
   chmod +x hashmonkeyd
   ```
2. Run:
   ```bash
   ./hashmonkeyd --testnet --check-updates=disabled --add-peer 155.4.209.124:48080
   ```
3. Type **`status`** when the prompt appears.

**Data folder:** `~/.hashmonkeycoin/testnet/`

### Check the node is working

- Daemon shows **testnet** in `status`.
- Explorer height increases: https://explorer.hashmonkeys.cloud
- Or from another machine (if RPC is exposed): `http://YOUR_IP:48081` — default install binds RPC to **localhost only** (safer).

### Stop the node

- In the daemon window: type **`exit`** and press Enter, or close the window.

---

## Part 2 — GUI wallet setup

You need a **running testnet daemon** first (Part 1), unless you use a **remote node** (advanced).

### Windows

1. Make sure **`hashmonkeyd.exe`** is running with **`--testnet`** (see Part 1).
2. Start the wallet:
   - From the zip: `windows\wallet-gui\hashmonkey-wallet-gui.exe`  
   - Or run `start-hmny-testnet.ps1` (starts daemon + GUI).
3. **First time — create a wallet**
   - Choose language → **Advanced mode** (simple mode may require mainnet).
   - Network: select **Testnet**.
   - Create a new wallet, set a strong password, write down the **25-word seed** offline.
   - Restore height: use **0** for a brand-new testnet wallet, or ask the community for the current height if restoring later.
4. **Connect to your local node**
   - Settings → **Node** (or wizard remote node step).
   - **Local node** (not remote).
   - Address: **`127.0.0.1:48081`**
   - Network: **Testnet**
5. Wait until the wallet shows **Synchronized** / connected (bottom status).

### Linux

1. Run **`hashmonkeyd --testnet`** as in Part 1 (keep it running).
2. In another terminal:
   ```bash
   chmod +x ../wallet-gui/hashmonkey-wallet-gui
   ../wallet-gui/hashmonkey-wallet-gui
   ```
3. Same wizard steps: **Testnet**, **Advanced mode**, local node **`127.0.0.1:48081`**.

### Using a remote node (optional)

If you do not run a daemon locally, you can point the GUI at a public testnet RPC (if offered by the operator):

- Settings → Node → **Remote node**
- Address: `155.4.209.124:48081` (only if that RPC is open to the internet — the public seed may be localhost-only)
- Network: **Testnet**

For most testers, **local daemon + 127.0.0.1:48081** is the reliable setup.

### Receive testnet coins (mining)

Testnet coins have **no real value**. To get coins for testing:

1. Copy your wallet **address** from the Receive page.
2. On the machine running the daemon, start mining to that address (example):
   ```text
   start_mining YOUR_ADDRESS 2
   ```
   (In the `hashmonkeyd` window, or via RPC — community docs may add a script.)

Or ask in community channels for testnet HMNY from the faucet/seed operator.

### Common issues

| Problem | Fix |
|---------|-----|
| Wallet says “disconnected” | Start `hashmonkeyd --testnet` first; confirm node is `127.0.0.1:48081` and network is **Testnet**. |
| Daemon on mainnet by mistake | Restart with **`--testnet`**. |
| Height stays at 0 | Add peer: `--add-peer 155.4.209.124:48080` |
| “Monero” in old log lines | Re-download **v0.2.1-testnet** release binaries (newer builds say HashmonkeyCoin). |
| Windows blocks zip | Extract on PC; Defender may flag mining tools — core daemon/GUI from release are intended for use. |

### What testnet is for

- Testing wallets, sends, and mining  
- Trying the block explorer and seed node  
- **Not** real money — do not use testnet keys on other coins  

Mainnet is **not launched** yet. Do not expect mainnet seeds or value.

---

## Quick reference

```powershell
# Windows — one-liner after extracting zip
cd windows
.\hashmonkeyd.exe --testnet --check-updates=disabled --add-peer 155.4.209.124:48080
```

```bash
# Linux
./hashmonkeyd --testnet --check-updates=disabled --add-peer 155.4.209.124:48080
```

**GUI node setting:** `127.0.0.1:48081` · **Network:** Testnet

Questions / issues: [hashmonkeycoin repository](https://github.com/stabner/hashmonkeycoin/issues)
