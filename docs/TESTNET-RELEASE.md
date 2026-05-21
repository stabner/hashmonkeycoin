# HMNY testnet public release checklist

## Network

| Service | Value |
|---------|--------|
| P2P | `155.4.209.124:48080` or `seednode.hashmonkey.cloud:48080` (after DNS) |
| RPC | `155.4.209.124:48081` |
| Explorer | https://explorer.hashmonkeys.cloud |
| Network | **Testnet** (not mainnet) |

## Wallet / GUI

- Remote node: `155.4.209.124:48081`
- Bootstrap: **empty**
- Network: **Testnet**

## Seed node (NAS)

```bash
bash scripts/hmny-restart-testnet-mining.sh   # 4 threads, keep chain
# or fresh chain:
bash scripts/hmny-testnet-reset.sh
```

## GitHub release assets

- `hmny-testnet-linux-x64.zip`
- `hmny-testnet-windows-x64.zip`
- `SHA256SUMS.txt` inside each zip and on release page

## Before announcing

- [ ] DNS: `seednode.hashmonkey.cloud` → `155.4.209.124`
- [ ] Router: TCP 48080, 48081 (optional), 80/443
- [ ] Seed status shows `mining at` and height increasing
- [ ] Explorer shows recent blocks
