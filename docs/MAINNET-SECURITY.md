# HashmonkeyCoin (HMNY) — mainnet security & who can “launch”

## Short answers

| Question | Answer |
|----------|--------|
| **Can only I start mainnet?** | **No.** Anyone with the binaries can run `hashmonkeyd` **without** `--testnet` (that is mainnet). There is no license key or remote kill switch. |
| **Can random people mine mainnet today?** | **No**, unless they rebuild or use a binary that enables it **and** pass `--allow-mainnet-mining`. Default builds block mainnet mining. |
| **Can random people hijack the testnet?** | They can run their own testnet nodes and mine testnet; they **cannot** replace your chain without peers accepting their fork. Your seed + DNS controls what **your** users sync to. |
| **Is mainnet “live” right now?** | Only if **you** run non-testnet nodes and publish seeds. Embedded **mainnet seed IPs are empty** for `hashmonkeycoin`; Monero seeds are **not** used. |
| **What do I control for launch?** | Genesis (fixed in code), first seed nodes, DNS, when you enable `--allow-mainnet-mining`, and what you publish as the official release. |

## What the code enforces (mainnet)

1. **Mainnet mining off by default**  
   - CLI: `--start-mining` on mainnet fails unless the daemon was started with `--allow-mainnet-mining`.  
   - RPC: `POST /start_mining` returns an error on mainnet without that flag.  
   - See `miner.cpp` and `core_rpc_server.cpp`.

2. **No Monero bootstrap on HMNY**  
   - For `CRYPTONOTE_NAME == "hashmonkeycoin"`, hardcoded Monero seed IPs are **not** added.  
   - **Testnet** seeds: `seednode.hashmonkey.cloud:48080` and `155.4.209.124:48080`.  
   - **Mainnet** seed list in code is **empty** until you add your own IPs at launch.

3. **Separate networks**  
   - Testnet ports **48080/48081**, mainnet uses default Monero-style ports unless you change them.  
   - Testnet genesis/nonce differ from mainnet (`cryptonote_config.h`).

## What the code does *not* enforce

- **Exclusive right to run a node** — open-source style; anyone can run the daemon.  
- **Secret mainnet** — genesis is in the binary; a motivated party can start a private mainnet fork.  
- **Your NAS seed** — security is operational (firewall, DNS, only you operating the official seed), not cryptographic “only stabner can launch.”

## Recommended launch checklist (when you go mainnet)

1. Run seeds with **`--allow-mainnet-mining`** only on machines you control (if you want to mine).  
2. Add **mainnet** seed hostnames/IPs in `net_node.inl` (or exclusive nodes), rebuild, publish **one** official release.  
3. Do **not** ship public downloads with `--allow-mainnet-mining` baked in unless you intend public mining.  
4. Publish genesis hash and seed list so wallets match **your** chain.  
5. Keep testnet on **48080/48081**; use default or dedicated mainnet ports for production.

## Testnet (current public network)

- Intended for public testing; mining is allowed on testnet.  
- Official seed: `seednode.hashmonkey.cloud:48080` (DNS → your NAS).  
- Resetting testnet = delete `~/.hashmonkeycoin/testnet` (see `scripts/hmny-testnet-reset.sh`).

## Testing without launching public mainnet

See **[MAINNET-TESTING.md](MAINNET-TESTING.md)** — use testnet (public), stagenet/regtest (private), or LAN-only mainnet rehearsal with `--allow-mainnet-mining` and no port forward.
