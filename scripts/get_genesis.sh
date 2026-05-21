#!/bin/bash
set -e
BIN=/home/monkeynas/hashmonkey/src/hashmonkey-core/build/Linux/master/release/bin
rm -rf /tmp/hmnygenesis
$BIN/hashmonkeyd --data-dir /tmp/hmnygenesis --detach --no-sync
sleep 5
curl -s http://127.0.0.1:28081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_block","params":{"height":0}}' > /tmp/genesis.json
python3 -c "import json; print(json.load(open('/tmp/genesis.json'))['result']['hash'])"
$BIN/hashmonkeyd --data-dir /tmp/hmnygenesis exit 2>/dev/null || true
