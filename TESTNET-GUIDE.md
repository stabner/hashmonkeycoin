# HashmonkeyCoin testnet — setup guide

Public testnet only. **Always choose Testnet** in the wallet until mainnet is announced.

| | |
|--|--|
| **Download** | [GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases) — use the latest **`v0.2.4-testnet`** (or newer testnet tag) |
| **Seed (P2P)** | `seednode.hashmonkeys.cloud:48080` |
| **Seed (wallet RPC)** | `seednode.hashmonkeys.cloud:48081` |
| **Explorer** | https://explorer.hashmonkeys.cloud |

Verify files with **`SHA256SUMS.txt`** on the release page.

---

## Before you start (upgrading from an older testnet build)

Current testnet follows **mainnet-style hardforks** (RandomX from block **12**). Old blockchain data will not sync.

1. Close `hashmonkeyd.exe` and `hashmonkey-wallet-gui.exe`.
2. Delete the chain folder (wallet files are usually elsewhere):
   - **Windows:** Win+R → `%ProgramData%\hashmonkeycoin\testnet` → delete everything inside.
   - **Linux:** delete `~/.hashmonkeycoin/testnet/`
3. Install binaries from the latest testnet release and continue below.

---

## Easiest path — wallet only (recommended for new users)

No manual daemon. No blockchain download on your PC.

1. Download **`hmny-testnet-windows-x64.zip`** (or the Linux tarball) and extract it.
2. Open the **`windows\wallet-gui`** folder (Linux: `ubuntu/wallet-gui` if present, else use daemon path in the zip README).
3. Run **`hashmonkey-wallet-gui.exe`**.
4. Wizard:
   - **Language** → your choice  
   - **Network:** **Testnet**  
   - **Testnet — quick start (recommended)**  
   - Create a wallet (use restore height **0** for a brand-new wallet)  
5. Wait until the bottom bar shows **connected** / synchronized (a few minutes is normal).

The wallet uses the public seed RPC at **`seednode.hashmonkeys.cloud:48081`**.

---

## Full node path (download the chain on your PC)

Use this if you want your own `hashmonkeyd`, mining, or maximum privacy.

1. Extract the release zip.
2. Put **`hashmonkeyd.exe`** and **`hashmonkey-wallet-gui.exe`** in the **same** folder (`windows\wallet-gui`).
3. Run **`hashmonkey-wallet-gui.exe`**.
4. Wizard: **Testnet** → **Testnet — full node**.
5. On the daemon step, leave **Start a node automatically** enabled (default).
6. Wait until status shows **Synchronized** (first sync can take a while).

The GUI starts the daemon with public peers and bootstrap to the seed. Your wallet talks to **`127.0.0.1:48081`** on your PC.

### Windows — start the daemon manually (optional)

Open PowerShell in `windows\wallet-gui`:

```powershell
.\hashmonkeyd.exe --testnet --check-updates=disabled
```

v0.2.4+ builds already use `seednode.hashmonkeys.cloud:48080`. Optional extra peer:

```powershell
.\hashmonkeyd.exe --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
```

In the daemon window, type **`status`**. You want **testnet**, a growing **height**, and **`(Nout)` ≥ 1**.

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

## Ports (do not mix these up)

| Port | Purpose | Wallet GUI? |
|------|---------|-------------|
| **48080** | P2P between daemons | **No** |
| **48081** | RPC (wallet ↔ daemon) | **Yes** |

- Local wallet with your own daemon: **`127.0.0.1:48081`**
- Remote wallet (quick start): **`seednode.hashmonkeys.cloud:48081`**

---

## Mining on the pool

1. Use a **testnet** wallet address from the **Receive** page.
2. Point your miner at the pool host and port listed on [HashMonkeys.cloud](https://hashmonkeys.cloud) for HMNY testnet.
3. Pool dashboard **“Total paid”** means the pool **sent** a payout transaction. Your wallet only shows coins after:
   - the tx is **included in a block**, and  
   - about **10 blocks** (~20 minutes at ~2 min/block) for **spendable** balance.

Check **History** in the GUI. If the pool gives a transaction ID, look it up on the explorer.

### When are testnet coins spendable?

| How you got coins | Shows in wallet | Spendable (can send) |
|-------------------|-----------------|----------------------|
| **Pool payout** | ~1 block after confirmation | ~**10 blocks** later |
| **Mined block reward** | ~1 block | ~**60 blocks** later (~2 hours) |

Testnet coins have **no real value**.

---

## Seed operator checklist (public testnet)

Remote users connect **out** to **`seednode.hashmonkeys.cloud`**. They do not need your home LAN address.

1. **Router:** forward **TCP 48080** (P2P) and **TCP 48081** (RPC) to the machine running the seed.
2. **DNS:** `seednode.hashmonkeys.cloud` → your public IP (A record).
3. Run the seed with **testnet**, **`--public-node`**, and **restricted RPC** on **48081** (see repo script `scripts/hmny-testnet-public-node.sh`).
4. **Test from outside your LAN:**  
   `Test-NetConnection seednode.hashmonkeys.cloud -Port 48080`  
   (or an online port checker) — must show **open**, not filtered.

---

## Troubleshooting

| Problem | What to do |
|---------|------------|
| Wallet **disconnected** | Network = **Testnet**. Quick start: `seednode.hashmonkeys.cloud:48081`. Full node: start `hashmonkeyd --testnet`, node = `127.0.0.1:48081`. |
| Used port **48080** in the wallet | Wrong port — wallet needs **48081**. |
| Balance **0** after pool “paid” | Open **History**; wait for tx in a block + ~10 blocks; stay **connected** and **synced**. |
| Height **0** / no sync | Daemon needs `--testnet` and peers; check **`(Nout) ≥ 1`** in `status`. |
| Explorer shows **no peers** | Normal on public RPC — P2P is hidden there. Check your own `status` / `print_cn`. |
| **`(Min)` is 0** | Normal at home without port forward; outbound sync still works. |
| Same home network as seed, sync fails | Public hostname can fail from inside the same LAN (router hairpin). Try **mobile data** or ask the operator for a LAN hostname. |
| Linux `libboost` missing | Use `./run-hashmonkeyd.sh` from the `ubuntu/` folder (bundled `lib/`). |
| Wrong chain / weird heights | Delete testnet chain folder (see top), re-sync with latest release. |

---

## Quick reference

**Wallet only:** run GUI → Testnet → **Quick start** → create wallet.

**Full node:**

```powershell
cd windows\wallet-gui
.\hashmonkeyd.exe --testnet --check-updates=disabled
.\hashmonkey-wallet-gui.exe
```

```bash
cd ubuntu
./run-hashmonkeyd.sh --testnet --check-updates=disabled --add-peer seednode.hashmonkeys.cloud:48080
```

**GUI node (local daemon):** `127.0.0.1:48081` · **Network:** Testnet

Questions: [GitHub Issues](https://github.com/stabner/hashmonkeycoin/issues)
