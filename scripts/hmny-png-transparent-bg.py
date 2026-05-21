#!/usr/bin/env python3
"""Remove near-black backgrounds from HMNY PNG assets (alpha channel)."""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image


def remove_black_background(src: Path, dst: Path, threshold: int = 28) -> None:
    img = Image.open(src).convert("RGBA")
    pixels = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if r <= threshold and g <= threshold and b <= threshold:
                pixels[x, y] = (r, g, b, 0)
    img.save(dst, optimize=True)
    print(f"wrote {dst} ({w}x{h})")


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    images = root / "hashmonkey-gui" / "images"
    targets = ["hmny-hero.png", "hmny-card-logo.png"]
    for name in targets:
        src = images / name
        if not src.exists():
            print(f"missing {src}", file=sys.stderr)
            return 1
        remove_black_background(src, src)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
