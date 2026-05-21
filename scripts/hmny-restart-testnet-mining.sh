#!/bin/bash
# Restart testnet daemon with 4 mining threads (keeps existing chain).
set -euo pipefail

ROOT="${HMNY_ROOT:-/home/monkeynas/hashmonkey}"
BIN="${HMNY_BIN:-$ROOT/src/hashmonkey-gui/build/release/bin}"
DATA="${HMNY_DATA:-$HOME/.hashmonkeycoin/testnet}"
ADDR="${HMNY_MINING_ADDR:-9u5JNEvePkpMn8cL3KnQ5qDS2NBnbigsQUvn1QcmaZPLKWUNJWftgSmWhKNnuQisXDj7nzodaAuYkCuXjiFtNTXrPxbZT4Z}"
THREADS="${HMNY_MINING_THREADS:-4}"

pkill -f 'hashmonkeyd.*--testnet' 2>/dev/null || true
sleep 3
pkill -9 -f 'hashmonkeyd.*--testnet' 2>/dev/null || true
sleep 2

"$BIN/hashmonkeyd" --testnet --non-interactive --detach \
  --data-dir "$DATA" \
  --start-mining="$ADDR" --mining-threads="$THREADS" \
  --rpc-bind-ip=0.0.0.0 --rpc-bind-port=48081 --confirm-external-bind \
  --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080 \
  --log-level=1

sleep 10
python3 /tmp/hmny-start-mining.py "$ADDR" "$THREADS" 2>/dev/null || true
sleep 5
"$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status
