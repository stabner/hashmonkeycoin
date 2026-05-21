#!/bin/bash
# Wipe testnet blockchain data and restart from genesis with 1-thread mining.
set -euo pipefail

ROOT="${HMNY_ROOT:-/home/monkeynas/hashmonkey}"
BIN="${HMNY_BIN:-$ROOT/src/hashmonkey-gui/build/release/bin}"
DATA="${HMNY_DATA:-$HOME/.hashmonkeycoin/testnet}"
ADDR="${HMNY_MINING_ADDR:-9u5JNEvePkpMn8cL3KnQ5qDS2NBnbigsQUvn1QcmaZPLKWUNJWftgSmWhKNnuQisXDj7nzodaAuYkCuXjiFtNTXrPxbZT4Z}"
BACKUP="${HMNY_BACKUP:-$HOME/.hashmonkeycoin/testnet-backup-$(date +%Y%m%d-%H%M%S)}"

if [ ! -x "$BIN/hashmonkeyd" ]; then
  echo "hashmonkeyd not found: $BIN/hashmonkeyd"
  exit 1
fi

echo "=== Stopping testnet daemons ==="
pkill -f 'hashmonkeyd.*--testnet' 2>/dev/null || true
sleep 3
if pgrep -f 'hashmonkeyd.*--testnet' >/dev/null; then
  pkill -9 -f 'hashmonkeyd.*--testnet' 2>/dev/null || true
  sleep 2
fi

if [ -d "$DATA" ]; then
  echo "=== Backing up $DATA -> $BACKUP ==="
  mv "$DATA" "$BACKUP"
fi
mkdir -p "$DATA"

echo "=== Starting fresh testnet (genesis + mining) ==="
"$BIN/hashmonkeyd" --testnet --non-interactive --detach \
  --data-dir "$DATA" \
  --start-mining="$ADDR" --mining-threads=4 \
  --rpc-bind-ip=0.0.0.0 --rpc-bind-port=48081 --confirm-external-bind \
  --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080 \
  --log-level=1

for i in $(seq 1 24); do
  sleep 5
  if out=$("$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status 2>/dev/null); then
    echo "$out"
    if echo "$out" | grep -q 'mining at'; then
      echo "=== Reset complete: mining active ==="
      exit 0
    fi
    if echo "$out" | grep -qE 'Height: [2-9]/'; then
      echo "=== Chain advancing (check mining line above) ==="
      exit 0
    fi
  fi
done
echo "Daemon started; check status manually."
exit 0
