#!/bin/bash
# Start CPU mining via daemon HTTP /start_mining (not json_rpc).
set -euo pipefail
ADDR="${1:-9u5JNEvePkpMn8cL3KnQ5qDS2NBnbigsQUvn1QcmaZPLKWUNJWftgSmWhKNnuQisXDj7nzodaAuYkCuXjiFtNTXrPxbZT4Z}"
THREADS="${2:-1}"
RPC="${RPC_URL:-http://127.0.0.1:48081}"

cat > /tmp/hmny-start-mining.json <<EOF
{"miner_address":"$ADDR","threads_count":$THREADS,"do_background_mining":false,"ignore_battery":true}
EOF

curl -s -X POST "${RPC}/start_mining" \
  -H 'Content-Type: application/json' \
  --data-binary @/tmp/hmny-start-mining.json
echo
