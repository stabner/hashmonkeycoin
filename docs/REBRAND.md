# HashmonkeyCoin rebrand (daemon / CLI)

## Fixed in source

- Startup banner: **HashmonkeyCoin (v0.18.1.0-unknown)** instead of `Monero 'Fluorine Fermi'`.
- **No Monero update checks**: default `--check-updates=disabled`; no MoneroPulse / getmonero.org polling.
- Update RPC points to **GitHub releases** for HashmonkeyCoin only.
- Data dir remains `%ProgramData%\hashmonkeycoin\` (correct).

## Windows testnet launcher

Use `windows\start-hmny-testnet.ps1` — starts:

- `--testnet` (P2P **48080**, RPC **48081** — not mainnet 28081)
- `--check-updates=disabled`

## Rebuild required

After pulling these changes, rebuild **both** Linux and Windows `hashmonkeyd` / wallet-cli (see `docs/BUILD-SYNC.md`).

The GUI may still show Monero text in QML until the GUI project is rebranded separately.
