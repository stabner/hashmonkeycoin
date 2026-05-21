#!/bin/bash
set -euo pipefail
ROOT="${HMNY_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
CORE="${HMNY_CORE:-$ROOT/hashmonkey-core}"
BIN="${HMNY_BIN:-$CORE/build/Linux/master/release/bin}"
DATA="${HMNY_DATA:-$HOME/.hashmonkeycoin/testnet}"
ADDR_FILE="${HMNY_WALLET_DIR:-$ROOT/testnet-wallets}/hmny-testnet-seed.address.txt"
ADDR=$(grep -oE '[0-9A-Za-z]{95,}' "$ADDR_FILE" | head -1)

pkill -f 'hashmonkeyd.*testnet' 2>/dev/null || true
sleep 2

"$BIN/hashmonkeyd" --testnet --non-interactive --detach \
  --data-dir "$DATA" \
  --start-mining="$ADDR" --mining-threads=2 \
  --rpc-bind-ip=0.0.0.0 --rpc-bind-port=48081 --confirm-external-bind \
  --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080

for i in $(seq 1 24); do
  sleep 10
  OUT=$("$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status 2>&1 || true)
  echo "$OUT"
  echo "$OUT" | grep -q 'mining at' && exit 0
  HEIGHT=$(echo "$OUT" | grep -oP 'Height: \K[0-9]+' | head -1)
  if [ "${HEIGHT:-0}" -ge 3 ]; then
    exit 0
  fi
done
exit 1
