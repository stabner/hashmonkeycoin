#!/usr/bin/env python3
import json
import sys
import urllib.request

addr = sys.argv[1] if len(sys.argv) > 1 else ""
threads = int(sys.argv[2]) if len(sys.argv) > 2 else 1
rpc = "http://127.0.0.1:48081/start_mining"

body = json.dumps({
    "miner_address": addr,
    "threads_count": threads,
    "do_background_mining": False,
    "ignore_battery": True,
}).encode()

req = urllib.request.Request(rpc, body, {"Content-Type": "application/json"})
print(urllib.request.urlopen(req, timeout=30).read().decode())
