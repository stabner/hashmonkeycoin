# HMNY testnet — seed node & block explorer

| Service | Hostname | Port | Notes |
|---------|----------|------|--------|
| Testnet P2P (seed) | `seednode.hashmonkey.cloud` | **48080** | Add DNS **A** → `155.4.209.124` |
| Testnet RPC | same host (or LAN IP) | **48081** | Wallets: remote node, empty bootstrap |
| Block explorer | `explorer.hashmonkeys.cloud` | **443/80** | Nginx → `127.0.0.1:8083` |

`explorer.hashmonkeys.cloud` already aliases `hashmonkeys.cloud` (`155.4.209.124`).

## DNS (required for seed hostname)

At your DNS provider:

```
seednode.hashmonkey.cloud   A   155.4.209.124
```

(Optional) `AAAA` if you have IPv6 on the same host.

## NAS (monkeynas) — start services

```bash
export HMNY_ROOT=/home/monkeynas/hashmonkey
bash $HMNY_ROOT/scripts/hmny-testnet-public-node.sh
bash $HMNY_ROOT/scripts/hmny-explorer-start.sh   # first run builds OME
sudo cp $HMNY_ROOT/infra/nginx/explorer.hashmonkeys.cloud.conf /etc/nginx/sites-available/
sudo ln -sf /etc/nginx/sites-available/explorer.hashmonkeys.cloud.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d explorer.hashmonkeys.cloud   # optional TLS
```

## Firewall / router

Forward to the NAS:

- **48080** TCP (testnet P2P)
- **48081** TCP (testnet RPC, if public wallets needed)
- **80 / 443** (explorer website)

## Wallet / GUI

- Remote node: `seednode.hashmonkey.cloud:48081` (or `155.4.209.124:48081` until DNS works)
- Bootstrap address: **empty**
- Network: **Testnet**

## Rebuild daemon with embedded seed (optional)

After changing `hashmonkey-core/src/p2p/net_node.inl`, rebuild `hashmonkeyd` and restart the public node script.
