#!/bin/bash
echo '{"jsonrpc":"2.0","id":"0","method":"get_info"}' > /tmp/rpc.json
curl -s -X POST http://127.0.0.1:48081/json_rpc -H 'Content-Type: application/json' --data-binary @/tmp/rpc.json
