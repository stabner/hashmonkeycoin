# HashmonkeyCoin (HMNY)

HashmonkeyCoin is a Monero-based privacy coin fork with HMNY branding, custom network parameters, and a community-first roadmap. This repository is **not affiliated with** the [Monero Project](https://www.getmonero.org/).

## Network

| | Mainnet | Testnet |
|--|---------|---------|
| P2P | 28080 | 48080 |
| RPC | 28081 | 48081 |
| ZMQ | 28082 | 48082 |
| Address prefix | `9…` (mainnet) | testnet prefix in `cryptonote_config.h` |

- **Mainnet** is prepared but **not launched**: no public seeds; mining requires `--allow-mainnet-mining`.
- **Testnet** is for development and public testing. Configure seed nodes in `src/p2p/net_node.inl` or use `--add-peer` at deploy time.

## Repository layout

```
hashmonkey-core/  # HMNY core (hashmonkeyd, wallets, blockchain tools)
hashmonkey-gui/   # HMNY desktop GUI (hashmonkey-wallet-gui)
logo/             # Brand assets
```

Build `hashmonkey-core` first, then `hashmonkey-gui`. Prebuilt binaries are published via [GitHub Releases](https://github.com/stabner/hashmonkeycoin/releases), not stored in this repository.

## Coin distribution & supply

HMNY uses the same **Monero-style emission curve** as the upstream core (smooth reward decay + permanent tail emission). There is **no founder premine**, **no ICO allocation**, and **no hidden genesis payout**—only standard block rewards paid to miners (and fees).

| Topic | HMNY (mainnet parameters) |
|--------|---------------------------|
| **Premine / dev allocation** | **None** — genesis block follows the normal Cryptonote genesis layout; coins enter circulation only via block rewards |
| **Smallest unit** | 1 atomic unit = 10⁻¹² HMNY (`COIN` = 10¹² atomic units per 1 HMNY) |
| **Display decimals** | 12 |
| **Block time (v2+)** | ~**2 minutes** (`DIFFICULTY_TARGET_V2` = 120s) |
| **Proof-of-work** | **RandomX** (CPU-oriented, Monero-compatible) |
| **First minable block reward** | ~**35.18 HMNY** (height 1+, empty `already_generated_coins`) |
| **Tail emission (per block)** | **0.6 HMNY** per block (~**0.3 HMNY/minute**) |
| **Main emission phase** | Smooth curve until tail; ~**18.1M HMNY** mined before the reward floor (~2.13M blocks at 2 min/block) |
| **Hard cap in code** | `MONEY_SUPPLY` uses the Monero formula constant (UINT64_MAX in `cryptonote_config.h`)—rewards taper via the emission function, not a Bitcoin-style halving schedule |
| **Fees** | Transaction fees go to the miner of the block (same as Monero) |

### How new coins are created

1. **Genesis (height 0)** — establishes the chain; no large pre-allocated community/treasury balance in protocol config.
2. **Mining rewards** — each block pays `get_block_reward()` from `cryptonote_basic_impl.cpp` (smooth decay, then tail).
3. **Tail phase** — after the main curve, every block pays at least **0.6 HMNY** forever (incentivizes long-term miners and network security).
4. **Treasury / community fund (future)** — not embedded in the current chain rules; any Phase 2 treasury would need a transparent, community-approved mechanism (see roadmap), separate from a silent premine.

### Testnet vs mainnet coins

**Testnet HMNY has no monetary value** and uses separate network IDs, ports, and genesis nonce. Testnet is for development, wallet testing, and public trials only. Mainnet is **not launched yet** (`--allow-mainnet-mining` is required until public launch).

### Reference (source of truth)

Emission constants: `hashmonkey-core/src/cryptonote_config.h` (`EMISSION_SPEED_FACTOR_PER_MINUTE`, `FINAL_SUBSIDY_PER_MINUTE`, `DIFFICULTY_TARGET_V2`, `COIN`). Reward logic: `hashmonkey-core/src/cryptonote_basic/cryptonote_basic_impl.cpp` → `get_block_reward()`.

## Quick start (testnet)

```bash
# Build core (Linux example)
cd hashmonkey-core && mkdir -p build/release && cd build/release
cmake -DCMAKE_BUILD_TYPE=Release ../.. && make -j$(nproc) hashmonkeyd hashmonkey-wallet-cli

# Run testnet daemon
./bin/hashmonkeyd --testnet --detach

# Create wallet (restore height 0 for new chain)
./bin/hashmonkey-wallet-cli --testnet --generate-new-wallet ~/hmny-test
```

## HMNY-specific changes (summary)

- Renamed binaries: `hashmonkeyd`, `hashmonkey-wallet-cli`, `hashmonkey-wallet-gui`
- Custom `NETWORK_ID`, ports, and address prefixes
- GUI defaults to **testnet**; mainnet mining gated behind `--allow-mainnet-mining`
- Wallet restore height `0` on fresh HMNY chains (no Monero block-height estimator)
- Solo mining works without waiting for a peer on genesis chains
- HashmonkeyCoin branding; Monero update checks disabled in `hashmonkeyd`

## License

This project includes code from the Monero Project, licensed under the BSD 3-Clause License. See copyright headers in source files and [Monero licensing](https://www.getmonero.org/library/licensing/).

---

## Roadmap

### Phase 1 — Foundation & Testnet · *Building the Jungle*

**Goals:** Fork and customize the HMNY blockchain core; configure RandomX; build seed nodes and bootstrap infrastructure; launch community channels; begin public testnet mining.

**Deliverables:** HMNY daemon, CLI wallet, public GitHub repository, seed nodes, testnet explorer, faucet, initial documentation, community Discord/Telegram, website integration with HashMonkeys.cloud.

**Technical focus:** RandomX optimization, network stability, fair launch preparation, difficulty tuning, anti-spam and peer protections, lightweight syncing research.

**Community:** Public testnet participation, miner onboarding, bug testing, transparent updates, early node operator incentives.

---

### Phase 2 — Fair Launch Mainnet · *Proof of Community*

**Goals:** Public HMNY mainnet launch; community-first mining; decentralized node infrastructure; sustainable treasury.

**Launch principles:** No ICO, no VC allocation, no hidden premine, transparent treasury, public mining from launch.

**Deliverables:** Mainnet release, GUI desktop wallet, Linux/Windows miners, community pools, network monitoring, explorer redundancy, bootstrap tools.

**Treasury** (transparent, community-reported) may fund global node expansion, server scaling, redundancy, DDoS mitigation, bandwidth, backups, monitoring, and ecosystem tools.

**Community incentives:** Early miner rewards, node operator recognition, events, mining competitions, governance preparation.

---

### Phase 3 — Gamer Mining Ecosystem · *Mine While You Sleep*

**Vision:** Passive, intelligent mining for everyday users and gamers—idle hardware contributes without disrupting normal PC use.

**Deliverables:** One-click mining launcher; idle mining mode (pause during gaming/streaming/heavy load); smart auto-throttle (CPU temp, load, apps); CPU/GPU resource management; mobile wallet and miner monitoring.

---

### Phase 4 — Idle Compute Economy · *Beyond Mining*

**Vision:** Evolve beyond traditional mining into decentralized compute powered by community hardware.

**Exploration:** AI inference, distributed rendering, edge compute, game server hosting, community cloud, distributed storage, compute marketplace.

**Deliverables:** Compute contribution framework, node reputation, reliability scoring, resource allocation, developer APIs.

---

### Phase 5 — Governance & Community Ownership · *Powered by the Community*

**Goals:** Long-term sustainability, transparent governance, community-driven funding.

**Deliverables:** Governance portal, treasury dashboard, proposals, voting, public infrastructure reporting, ecosystem grants.

---

**Long-term objective:** A decentralized mining ecosystem, gamer-friendly idle compute network, community-owned infrastructure, and a scalable platform for distributed participation.

*Powered by miners. Built by community. Scaled through participation.*
