#!/bin/bash
# Public HMNY testnet seed node (P2P 48080, RPC 48081). Run on seed host (e.g. monkeynas).
set -euo pipefail

ROOT="${HMNY_ROOT:-/home/monkeynas/hashmonkey}"
BIN="${HMNY_BIN:-$ROOT/src/hashmonkey-gui/build/release/bin}"
DATA="${HMNY_DATA:-$HOME/.hashmonkeycoin/testnet}"
WALLET_DIR="${HMNY_WALLET_DIR:-$ROOT/testnet-wallets}"
ADDR_FILE="$WALLET_DIR/hmny-testnet-seed.address.txt"
LOG="${HMNY_LOG:-$ROOT/testnet-public-node.log}"

exec >>"$LOG" 2>&1
echo "=== HMNY public testnet node $(date -Is) ==="

if [ ! -x "$BIN/hashmonkeyd" ]; then
  BIN="$ROOT/src.bak/hashmonkey-gui/build/release/bin"
fi
if [ ! -x "$BIN/hashmonkeyd" ]; then
  echo "hashmonkeyd not found under $BIN"
  exit 1
fi

MINING_ADDR=""
if [ -f "$ADDR_FILE" ]; then
  MINING_ADDR=$(grep -oE '[0-9A-Za-z]{95,}' "$ADDR_FILE" | head -1)
fi

pkill -f 'hashmonkeyd.*testnet' 2>/dev/null || true
sleep 2

EXTRA=()
if [ -n "$MINING_ADDR" ]; then
  EXTRA+=(--start-mining="$MINING_ADDR" --mining-threads=4)
fi

"$BIN/hashmonkeyd" --testnet --non-interactive --detach \
  --data-dir "$DATA" \
  "${EXTRA[@]}" \
  --rpc-bind-ip=0.0.0.0 --rpc-bind-port=48081 --confirm-external-bind \
  --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080 \
  --log-level=1

for i in $(seq 1 30); do
  sleep 5
  if "$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status 2>/dev/null | grep -q 'Height:'; then
    "$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status 2>/dev/null || true
    echo "=== Node up (seednode.hashmonkey.cloud:48080) ==="
    exit 0
  fi
done
echo "Daemon did not become ready; see $LOG"
exit 1
