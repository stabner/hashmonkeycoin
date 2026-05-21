#!/bin/bash
# Start minimal CPU mining on local testnet RPC (default 127.0.0.1:48081).
set -euo pipefail
ADDR="${1:-}"
THREADS="${2:-1}"
RPC="${HMNY_RPC:-http://127.0.0.1:48081/json_rpc}"
if [ -z "$ADDR" ] && [ -f "${HMNY_WALLET_DIR:-/home/monkeynas/hashmonkey/testnet-wallets}/hmny-testnet-seed.address.txt" ]; then
  ADDR=$(grep -oE '[0-9A-Za-z]{95,}' "${HMNY_WALLET_DIR:-/home/monkeynas/hashmonkey/testnet-wallets}/hmny-testnet-seed.address.txt" | head -1)
fi
[ -n "$ADDR" ] || { echo "Usage: $0 <testnet-address> [threads]"; exit 1; }
cat > /tmp/hmny-mine.json <<EOF
{"jsonrpc":"2.0","id":"0","method":"start_mining","params":{"miner_address":"$ADDR","threads_count":$THREADS,"is_background_mining":true}}
EOF
curl -s -X POST "$RPC" -H 'Content-Type: application/json' --data-binary @/tmp/hmny-mine.json
echo
sleep 5
hashmonkeyd --testnet --rpc-bind-port=48081 --non-interactive status 2>/dev/null || true
