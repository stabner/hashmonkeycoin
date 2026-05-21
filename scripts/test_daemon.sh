#!/bin/bash
BIN=/home/monkeynas/hashmonkey/src/hashmonkey-core/build/Linux/master/release/bin
rm -rf /tmp/hmnytest
$BIN/hashmonkeyd --data-dir /tmp/hmnytest --config-file /tmp/hmny-empty.conf --detach --no-sync
sleep 6
curl -s http://127.0.0.1:28081/json_rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' | python3 -c "import json,sys; r=json.load(sys.stdin)['result']; print('height',r['height'],'top',r['top_block_hash'][:16])"
$BIN/hashmonkeyd --data-dir /tmp/hmnytest exit 2>/dev/null || true
