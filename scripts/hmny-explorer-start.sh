#!/bin/bash
# HMNY testnet block explorer (Onion Monero Explorer) behind nginx at explorer.hashmonkeys.cloud
set -euo pipefail

ROOT="${HMNY_ROOT:-/home/monkeynas/hashmonkey}"
EXPLORER_DIR="${HMNY_EXPLORER_DIR:-$ROOT/onion-monero-blockchain-explorer}"
BUILD="$EXPLORER_DIR/build/xmrblocks"
DATA="${HMNY_DATA:-$HOME/.hashmonkeycoin/testnet}"
PORT="${HMNY_EXPLORER_PORT:-8083}"
LOG="${HMNY_LOG:-$ROOT/explorer.log}"
DAEMON_URL="${HMNY_DAEMON_URL:-http://127.0.0.1:48081}"

if [ ! -x "$BUILD" ]; then
  echo "Building explorer (first run may take 15–30 min)..."
  if [ ! -d "$EXPLORER_DIR" ]; then
    git clone --depth 1 https://github.com/moneroexamples/onion-monero-blockchain-explorer.git "$EXPLORER_DIR"
  fi
  mkdir -p "$EXPLORER_DIR/build"
  cd "$EXPLORER_DIR/build"
  rm -rf ./*
  cmake ..
  make -j"$(nproc)"
fi

pkill -f "xmrblocks.*--port $PORT" 2>/dev/null || true
sleep 1

BC_PATH="$DATA/lmdb"
nohup "$BUILD" -t \
  --port "$PORT" \
  --bindaddr 127.0.0.1 \
  --daemon-url "$DAEMON_URL" \
  -b "$BC_PATH" \
  --enable-json-api \
  --enable-autorefresh-option \
  --enable-emission-monitor \
  >>"$LOG" 2>&1 &

echo "Explorer listening on 127.0.0.1:$PORT (proxy explorer.hashmonkeys.cloud → this port)"
sleep 2
curl -sf -m 5 "http://127.0.0.1:$PORT/" >/dev/null && echo "Explorer HTTP OK" || echo "Explorer not responding yet; tail $LOG"
