#!/usr/bin/env python3
"""Revert accidental Monero->HashmonkeyCoin renames of QML module/type names."""
from pathlib import Path
import os
import sys

ROOT = Path(os.environ.get("MONERO_GUI_ROOT", r"D:\My_Blockchain\hashmonkey-gui"))

REVERT = [
    ("HashmonkeyCoinComponents", "MoneroComponents"),
    ("HashmonkeyCoinEffects", "MoneroEffects"),
    ("HashmonkeyCoinSettings", "MoneroSettings"),
    ("HashmonkeyCoinMerchant", "MoneroMerchant"),
    ("useHashmonkeyCoinClicked", "useMoneroClicked"),
    ("onUseHashmonkeyCoinClicked", "onUseMoneroClicked"),
    ("clearHashmonkeyCoinCardLabelText", "clearMoneroCardLabelText"),
    ("guiHashmonkeyCoinVersion", "guiMoneroVersion"),
]

count = 0
for p in ROOT.rglob("*.qml"):
    if "/hashmonkey-core/" in str(p).replace("\\", "/"):
        continue
    t = p.read_text(encoding="utf-8")
    orig = t
    for old, new in REVERT:
        t = t.replace(old, new)
    if t != orig:
        p.write_text(t, encoding="utf-8")
        count += 1
        print("fixed", p.relative_to(ROOT))

print(f"done: {count} files")
