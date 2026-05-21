# Testing mainnet behavior without launching public mainnet

## Safe networks (use these)

| Mode | Flag | Chain | Public risk |
|------|------|-------|-------------|
| **Testnet** (current) | `--testnet` | Own genesis, `NETWORK_ID` HMNY testnet, ports **48080/48081** | Public by design; **not** mainnet |
| **Stagenet** | `--stagenet` | Separate genesis nonce + `NETWORK_ID`, ports **38080/38081** | No HMNY seeds in binary → stays private unless you publish |
| **Regtest / fakechain** | `--regtest` | Local `FAKECHAIN`, fast HF for dev tests | LAN-only; resets easily |

Mainnet (`hashmonkeyd` with **no** `--testnet` / `--stagenet`):

- Empty seed list for `hashmonkeycoin` → does **not** join Monero or your testnet.
- Mining blocked unless `--allow-mainnet-mining`.
- **Risk** only if you: port-forward **18080**, publish seeds, or ship binaries with mining/launch flags enabled.

## Recommended workflow

### 1. Day-to-day (what you do now)

- Public **testnet** on NAS: explorer, seeds, mining OK.
- Wallets/GUI: **Testnet** + remote node `seednode.hashmonkey.cloud:48081`.

### 2. “Mainnet-like” rehearsal (private)

On a **LAN machine** (no router forward, no DNS):

```bash
hashmonkeyd --non-interactive --detach \
  --data-dir ~/.hashmonkeycoin/mainnet-rehearsal \
  --allow-mainnet-mining \
  --start-mining=<your-address> --mining-threads=1 \
  --p2p-bind-ip=127.0.0.1 \
  --rpc-bind-ip=127.0.0.1
```

- No `--testnet` → exercises **mainnet** code paths (mining gate, ports 18080/18081 by default).
- **127.0.0.1** bind → not reachable from the internet.
- Do **not** add mainnet seeds to `net_node.inl` until real launch.

### 3. Stagenet rehearsal (optional)

```bash
hashmonkeyd --stagenet --non-interactive --detach \
  --data-dir ~/.hashmonkeycoin/stagenet \
  --start-mining=<address> --mining-threads=1
```

Separate chain from testnet; good for wallet/GUI “another network” tests.

### 4. Automated / CI

```bash
hashmonkeyd --regtest --detach --data-dir /tmp/hmny-regtest ...
```

Uses `FAKECHAIN` (see `cryptonote_core.cpp`).

## What does *not* expose mainnet to the world

- Using **testnet** or **stagenet** only on the public NAS.
- **Not** port-forwarding **18080/18081** (mainnet defaults).
- **Not** publishing a mainnet release with `--allow-mainnet-mining` documented for everyone.
- **Not** adding mainnet seed IPs until launch day.

Anyone can still run mainnet **on their own PC** with your public binaries—that is unavoidable with open binaries. They get an isolated chain unless they coordinate peers with the same genesis + seeds as you.

## Later: “launch day” chain identity (merkle / genesis)

**Per-block merkle root** (tx tree in each block) is **computed** from transactions; you do not set it once at launch.

What actually defines “the official mainnet” at birth:

| Mechanism | Set when | Effect |
|-----------|----------|--------|
| `GENESIS_TX` + `GENESIS_NONCE` | Compile time (or regen before release) | Unique chain; different genesis → different network |
| `NETWORK_ID` (P2P magic) | Compile time | Peers only handshake with same ID |
| Mainnet seed list | Compile time + your DNS | Where wallets sync |
| Address prefixes | `cryptonote_config.h` | Wallet compatibility |

**Possible future features** (not implemented yet):

1. **`--allow-mainnet-launch`** — refuse to start mainnet P2P at all unless this flag is set (stricter than mining-only).
2. **Launch genesis in release channel only** — dev builds use placeholder genesis; release tag flips `GENESIS_TX` / nonce once.
3. **`--chain-launch-file`** — read signed genesis hash + `NETWORK_ID` at first start (operational, not secret).
4. **Time-locked HF** — consensus rejects blocks before `launch_time` (more work; true network-wide gate).

Changing “merkle root at launch” in practice means **changing genesis (or network id) in the official release build**, not a runtime slider on an already-shipped binary.

See also [MAINNET-SECURITY.md](MAINNET-SECURITY.md).
