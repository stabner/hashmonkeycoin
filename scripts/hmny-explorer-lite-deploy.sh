#!/bin/bash
# Deploy lightweight HMNY testnet explorer (static + RPC proxy via nginx).
set -euo pipefail
ROOT="${HMNY_ROOT:-/home/monkeynas/hashmonkey}"
WEB="${HMNY_EXPLORER_WEB:-/var/www/hmny-explorer}"
sudo mkdir -p "$WEB"
sudo cp "$ROOT/infra/explorer-lite/index.html" "$WEB/index.html"
sudo chown -R www-data:www-data "$WEB" 2>/dev/null || sudo chown -R nginx:nginx "$WEB" 2>/dev/null || true
sudo cp "$ROOT/infra/nginx/explorer.hashmonkeys.cloud.conf" /etc/nginx/sites-available/explorer.hashmonkeys.cloud.conf
sudo ln -sf /etc/nginx/sites-available/explorer.hashmonkeys.cloud.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
echo "Explorer lite: http://explorer.hashmonkeys.cloud (RPC proxied at /rpc/)"
