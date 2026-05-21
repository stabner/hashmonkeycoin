#!/bin/bash
set -euo pipefail
ROOT=/home/monkeynas/hashmonkey
SRC=/tmp/hmny-sync
for rel in src/cryptonote_core/cryptonote_core.cpp src/rpc/core_rpc_server.cpp src/p2p/net_node.inl src/cryptonote_basic/miner.cpp; do
  cp "$SRC/$rel" "$ROOT/src/hashmonkey-core/$rel"
  cp "$SRC/$rel" "$ROOT/src/hashmonkey-gui/monero/$rel"
done
mkdir -p "$ROOT/scripts"
tr -d '\r' < "$SRC/hmny-sync-build-nas.sh" > "$ROOT/scripts/hmny-sync-build-nas.sh"
chmod +x "$ROOT/scripts/hmny-sync-build-nas.sh"
if [ -f "$SRC/index.html" ]; then
  sudo cp "$SRC/index.html" /var/www/hmny-explorer/index.html 2>/dev/null || true
fi
pkill -f 'hashmonkeyd --data-dir /tmp/hmnytest' 2>/dev/null || true
echo apply-sync-ok
