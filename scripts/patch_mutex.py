#!/usr/bin/env python3
from pathlib import Path
for rel in (
    "hashmonkey-core/src/cryptonote_core/blockchain.h",
    "hashmonkey-gui/hashmonkey-core/src/cryptonote_core/blockchain.h",
):
    p = Path("/home/monkeynas/hashmonkey") / rel
    if not p.exists():
        print("skip", p)
        continue
    t = p.read_text(encoding="utf-8")
    if "#include <mutex>" not in t:
        t = t.replace("#include <atomic>\n", "#include <atomic>\n#include <mutex>\n")
        p.write_text(t, encoding="utf-8")
        print("patched", p)
    else:
        print("ok", p)
