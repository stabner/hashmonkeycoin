#!/bin/bash
# Bootstrap HMNY testnet: fresh chain, wallet, mine first blocks.
# Set HMNY_ROOT to your repo root. Set HMNY_TESTNET_SEED in net_node.inl or use --add-peer.
set -euo pipefail

ROOT="${HMNY_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
CORE="${HMNY_CORE:-$ROOT/hashmonkey-core}"
BIN="${HMNY_BIN:-$CORE/build/Linux/master/release/bin}"
DATA="${HMNY_DATA:-$HOME/.hashmonkeycoin/testnet}"
WALLET_DIR="${HMNY_WALLET_DIR:-$ROOT/testnet-wallets}"
WALLET_NAME=hmny-testnet-seed
LOG="${HMNY_LOG:-$ROOT/testnet-bootstrap.log}"

exec > >(tee -a "$LOG") 2>&1
echo "=== HMNY testnet bootstrap $(date -Is) ==="

if [ ! -x "$BIN/hashmonkeyd" ]; then
  echo "Building hashmonkeyd (release)..."
  cd "$CORE/build/Linux/master/release"
  make -j"$(nproc)" hashmonkeyd hashmonkey-wallet-cli
fi

pkill -f 'hashmonkeyd.*--testnet' 2>/dev/null || true
sleep 2
rm -rf "$DATA"
mkdir -p "$WALLET_DIR"

ADDR_FILE="$WALLET_DIR/${WALLET_NAME}.address.txt"
if [ ! -f "$ADDR_FILE" ]; then
  echo "Creating testnet wallet..."
  rm -f "$WALLET_DIR/${WALLET_NAME}" "$WALLET_DIR/${WALLET_NAME}.keys"
  "$BIN/hashmonkey-wallet-cli" --testnet --generate-new-wallet "$WALLET_DIR/$WALLET_NAME" \
    --password '' --mnemonic-language English --command exit 2>&1 | tail -20
  ADDR=$("$BIN/hashmonkey-wallet-cli" --testnet --wallet-file "$WALLET_DIR/$WALLET_NAME" --password '' \
    --command address 2>&1 | grep -oE '[0-9A-Za-z]{95,}' | head -1)
  echo "$ADDR" > "$ADDR_FILE"
fi

MINING_ADDR=$(grep -oE '[0-9A-Za-z]{95,}' "$ADDR_FILE" | head -1)
if [ -z "$MINING_ADDR" ]; then
  echo "Failed to read testnet address from $ADDR_FILE"
  exit 1
fi
echo "Mining address: $MINING_ADDR"

nohup "$BIN/hashmonkeyd" --testnet --non-interactive --detach \
  --data-dir "$DATA" \
  --start-mining="$MINING_ADDR" --mining-threads=2 \
  --rpc-bind-ip=127.0.0.1 --rpc-bind-port=48081 \
  --p2p-bind-ip=0.0.0.0 --p2p-bind-port=48080 \
  --log-level=1

echo "Waiting for blocks..."
for i in $(seq 1 90); do
  HEIGHT=$("$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status 2>/dev/null | grep -oP 'Height: \K[0-9]+' || echo 0)
  echo "  height=$HEIGHT"
  if [ "${HEIGHT:-0}" -ge 5 ]; then
    echo "Testnet ready (height >= 5)."
    break
  fi
  if [ "$i" -eq 3 ] && [ "${HEIGHT:-0}" -le 1 ]; then
    echo "Starting mining via RPC..."
    curl -s -X POST "http://127.0.0.1:48081/json_rpc" -H 'Content-Type: application/json' \
      -d "{\"jsonrpc\":\"2.0\",\"id\":\"0\",\"method\":\"start_mining\",\"params\":{\"miner_address\":\"$MINING_ADDR\",\"threads_count\":2}}" | head -c 200
    echo
  fi
  sleep 5
done

"$BIN/hashmonkeyd" --testnet --rpc-bind-port=48081 --non-interactive status 2>/dev/null || true
echo "Address file: $ADDR_FILE"
echo "=== Done $(date -Is) ==="
