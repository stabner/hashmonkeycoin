# HashmonkeyCoin testnet — user setup guide

Public testnet only. **Always use testnet** until mainnet is announced.

| Item | Value |
|------|--------|
| Download | [GitHub Release v0.2.1-testnet](https://github.com/stabner/hashmonkeycoin/releases/tag/v0.2.1-testnet) |
| Seed node | `seednode.hashmonkeys.cloud:48080` |
| P2P port | **48080** |
| RPC port | **48081** |
| Block explorer | https://explorer.hashmonkeys.cloud |

Verify downloads with `SHA256SUMS.txt` on the release page.

---

## Part 1 — Run a node (daemon)

The node (`hashmonkeyd`) stores the blockchain and talks to other peers. The wallet connects to it later.

### How P2P sync works (outgoing vs incoming)

| Direction | What it does | What you need |
|-----------|----------------|---------------|
| **Outgoing** | Your node connects *to* other peers (seed, peer list) and downloads blocks | Works from most home PCs — use `--add-peer` (below) |
| **Incoming** | Other peers connect *to* your node and share blocks with you | Router **port forward** TCP **48080** to this PC + allow inbound **48080** in the firewall |

For **wallet use and syncing the chain**, outgoing alone is enough. For a **full peer** that helps the network and can accept connections from others, set up **both**.

After the node is running, type **`status`**. A healthy node looks like:

```text
Height: …/… (…%) on testnet, …, …(8out)+2(in) connections
```

- **`(Nout)`** — outgoing peers (you want **≥ 1**, often 8–12).
- **`(Min)`** — incoming peers (**0** is normal behind NAT with no port forward; **≥ 1** means your node is reachable on the internet).

Use **`print_cn`** in the daemon window to list each connection and whether it is incoming or outgoing.

---

### Windows

1. Download **`hmny-testnet-windows-x64.zip`** from the release page and extract it (e.g. to `Desktop\HMNY`).
2. Open **PowerShell** in **`windows\wallet-gui`** (daemon and GUI live in the same folder).
3. Start the daemon (copy/paste this one line):
   ```powershell
   .\hashmonkeyd.exe --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
   ```
4. Wait until you see **“You are now synchronized with the network”** (may take a minute on first sync).
5. In the daemon window, type **`status`** and press Enter. You should see **testnet**, a **height** number, and **`(Nout)`** with **N ≥ 1**.

**Important:** Without `--testnet`, the daemon runs **mainnet** (wrong ports and chain). Always include `--testnet`.

**Data folder:** `C:\ProgramData\hashmonkeycoin\testnet\`

**Firewall (outgoing):** allow `hashmonkeyd.exe` on private networks if Windows asks.

#### Full peer on Windows (incoming + outgoing)

1. Use the same start command as above (it already listens on P2P port **48080**).
2. **Do not** add `--hide-my-port` (that stops your node from advertising itself to others).
3. **Router:** forward **TCP 48080** from your public IP to this PC’s LAN IP (same port **48080**).
4. **Windows Firewall — inbound rule** (PowerShell as Administrator):
   ```powershell
   New-NetFirewallRule -DisplayName "HMNY testnet P2P" -Direction Inbound -Protocol TCP -LocalPort 48080 -Action Allow
   ```
5. Restart the daemon if it was already running, wait a few minutes, then **`status`** again — look for **`(Min)`** with **M ≥ 1**.
6. Optional check: type **`print_cn`** — you should see lines marked as incoming connections.

If **`(Min)`** stays **0** but **`(Nout)`** is fine, the chain still syncs; only inbound reachability is missing (double-check port forward and firewall).

### Linux (Ubuntu 22.04+)

1. Download **`hmny-testnet-linux-x64.tar.gz`** and extract:
   ```bash
   tar -xzf hmny-testnet-linux-x64.tar.gz
   cd ubuntu/daemon
   chmod +x hashmonkeyd
   ```
2. Run:
   ```bash
   ./hashmonkeyd --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
   ```
3. Type **`status`** when the prompt appears — confirm **testnet**, growing **height**, and **`(Nout)`** with **N ≥ 1**.

**Data folder:** `~/.hashmonkeycoin/testnet/`

#### Full peer on Linux (incoming + outgoing)

1. Same daemon command as above.
2. **Do not** use `--hide-my-port`.
3. **Router:** forward **TCP 48080** → this machine’s LAN IP:48080.
4. **Host firewall** (if `ufw` is enabled):
   ```bash
   sudo ufw allow 48080/tcp comment 'HMNY testnet P2P'
   ```
5. Confirm bind on all interfaces (default). Optional explicit flags:
   ```bash
   ./hashmonkeyd --testnet --check-updates=disabled \
     --add-peer seednode.hashmonkeys.cloud:48080 \
     --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080
   ```
6. After a few minutes: **`status`** should show **`(Min)`** ≥ 1 when reachable; **`print_cn`** lists incoming peers.

---

### Optional: public RPC node (`--public-node`)

Separate from P2P block sync: **`--public-node`** lets other users attach wallets to your RPC (restricted mode) and advertises that over P2P. Only use this if you intend to host a remote node for others.

Example (Linux server; **not** for a typical home wallet PC):

```bash
./hashmonkeyd --testnet --check-updates=disabled \
  --add-peer seednode.hashmonkeys.cloud:48080 \
  --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080 \
  --public-node \
  --rpc-bind-ip=0.0.0.0 --rpc-bind-port=48081 --confirm-external-bind
```

Also forward **48081** if RPC should be reachable from the internet. Keep RPC on **localhost** (`127.0.0.1:48081`) for normal wallet use — safer.

---

### Check the node is working

- Daemon shows **testnet** in `status`.
- **`(Nout)` ≥ 1** — node is talking to the network (required).
- **`(Min)` ≥ 1** — node accepts inbound P2P (full peer; optional at home).
- Height catches up to the explorer: https://explorer.hashmonkeys.cloud
- **`print_cn`** shows a mix of incoming/outgoing when fully peered.
- RPC: default install binds to **localhost only** (`127.0.0.1:48081`) — good for local GUI; do not expose RPC unless you know the risks.

### Stop the node

- In the daemon window: type **`exit`** and press Enter, or close the window.

---

## Part 2 — GUI wallet setup

You need a **running testnet daemon** first (Part 1), unless you use a **remote node** (advanced).

### Windows

1. Make sure **`hashmonkeyd.exe`** is running with **`--testnet`** from **`windows\wallet-gui`** (see Part 1).
2. Start the wallet in the **same folder** (daemon must already be running):
   - `.\hashmonkey-wallet-gui.exe`
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
- Address: `seednode.hashmonkeys.cloud:48081` (only if RPC is open to the internet — default seed is localhost-only)
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
| Height stays at 0 / no sync | Add peer: `--add-peer seednode.hashmonkeys.cloud:48080`; check **`(Nout)`** in `status`. |
| **`(Nout)` is 0** | Firewall blocking outbound, or no internet; allow daemon through firewall; confirm seed hostname resolves. |
| **`(Min)` is 0** but outbound OK | Normal without port forward. For full peer: forward **48080/TCP**, allow inbound firewall, remove `--hide-my-port`, restart daemon. |
| Log: “No incoming connections” | Open **48080** on router + firewall toward this host (see full peer steps above). |
| “Monero” in old log lines | Re-download **v0.2.1-testnet** release binaries (newer builds say HashmonkeyCoin). |
| Windows blocks zip | Extract on PC; Defender may flag mining tools — core daemon/GUI from release are intended for use. |

### What testnet is for

- Testing wallets, sends, and mining  
- Trying the block explorer and seed node  
- **Not** real money — do not use testnet keys on other coins  

Mainnet is **not launched** yet. Do not expect mainnet seeds or value.

---

## Quick reference

**Sync + wallet (outgoing peers only):**

```powershell
# Windows
cd windows\wallet-gui
.\hashmonkeyd.exe --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
# then: .\hashmonkey-wallet-gui.exe
```

```bash
# Linux
./hashmonkeyd --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
```

**Full peer (outgoing + incoming):** same commands + router forward **TCP 48080** + inbound firewall rule. Verify with `status` → `(8out)+(2in)` and `print_cn`.

**GUI node setting:** `127.0.0.1:48081` · **Network:** Testnet

Questions / issues: [hashmonkeycoin repository](https://github.com/stabner/hashmonkeycoin/issues)
