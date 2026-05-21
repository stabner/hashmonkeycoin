#!/usr/bin/env python3
"""Apply HMNY branding assets and safe QML string updates."""
from pathlib import Path
import os
import re

ROOT = Path(os.environ.get("MONERO_GUI_ROOT", r"D:\My_Blockchain\hashmonkey-gui"))
LOGO_DIR = Path(os.environ.get("HMNY_LOGO_DIR", r"D:\My_Blockchain\logo"))
ICON128 = LOGO_DIR / "128.png"
HMNY = LOGO_DIR / "hmny.png"
HERO = LOGO_DIR / "Hero.png"
IMG = ROOT / "images"
ACCENT = (91, 192, 235)  # #5BC0EB

for p in (ICON128, HMNY, HERO):
    if not p.exists():
        raise SystemExit(f"Missing: {p}")

try:
    from PIL import Image
except ImportError:
    import subprocess
    subprocess.check_call(["pip", "install", "pillow", "-q"])
    from PIL import Image

icon128 = Image.open(ICON128).convert("RGBA")
splash = Image.open(HMNY).convert("RGBA")
hero = Image.open(HERO).convert("RGBA")


def save_png(path: Path, src: Image.Image, size: tuple[int, int] | None = None):
    path.parent.mkdir(parents=True, exist_ok=True)
    out = src.resize(size, Image.Resampling.LANCZOS) if size else src.copy()
    out.save(path, "PNG")


def save_png_fit(path: Path, src: Image.Image, max_dim: int):
    """Resize keeping aspect ratio (fits inside max_dim box)."""
    w, h = src.size
    scale = min(max_dim / w, max_dim / h)
    save_png(path, src, (max(1, int(w * scale)), max(1, int(h * scale))))


def save_ico_from_128(path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)
    icon128.resize((128, 128), Image.Resampling.LANCZOS).save(path, format="ICO")


def tint_orange_to_accent(src: Image.Image) -> Image.Image:
    """Recolor orange UI icons to HMNY light blue."""
    img = src.convert("RGBA")
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 8:
                continue
            if a > 8 and r > 130 and g < 210 and b < 180 and (r - g) > 25:
                px[x, y] = (ACCENT[0], ACCENT[1], ACCENT[2], a)
    return img


# --- exe icon + titlebar (128 keeps full color in dark + light theme) ---
save_ico_from_128(IMG / "appicon.ico")
save_png(IMG / "hmny-titlebar-128.png", icon128, (128, 128))
save_png(IMG / "titlebarLogo.png", icon128, (36, 36))
save_png(IMG / "titlebarLogo@2x.png", icon128, (72, 72))
save_png(IMG / "themes/white/titlebarLogo.png", icon128, (36, 36))
save_png(IMG / "themes/white/titlebarLogo@2x.png", icon128, (72, 72))

# --- welcome hero + account card logo ---
save_png(IMG / "hmny-hero.png", hero, (480, 270))
save_png_fit(IMG / "hmny-card-logo.png", icon128, 110)
save_png(IMG / "hmny-logo.png", splash, (256, 256))
save_png(IMG / "hmny-splash.png", splash, (400, 400))
save_png(IMG / "moneroLogo_white.png", icon128, (64, 64))

# --- blue-tinted UI icons (wizard, warnings, nodes, etc.) ---
ORANGE_ICONS = [
    "remote-node.png", "local-node.png", "local-node-full.png",
    "lightning.png", "lightning@2x.png",
    "create-wallet.png", "create-wallet@2x.png",
    "restore-wallet-from-hardware.png", "restore-wallet-from-hardware@2x.png",
    "open-wallet-from-file.png", "open-wallet-from-file@2x.png",
    "restore-wallet.png", "restore-wallet@2x.png",
    "warning.png", "warning@2x.png",
    "write-down.png", "write-down@2x.png",
    "busy-indicator.png", "busy-indicator@2x.png",
]
for name in ORANGE_ICONS:
    src = IMG / name
    if src.exists():
        save_png(IMG / ("hmny-" + name), tint_orange_to_accent(Image.open(src)))

qrc = ROOT / "qml.qrc"
t = qrc.read_text(encoding="utf-8")
new_entries = [
    "images/hmny-hero.png",
    "images/hmny-titlebar-128.png",
    "images/hmny-card-logo.png",
    "images/hmny-remote-node.png",
    "images/hmny-local-node.png",
    "images/hmny-local-node-full.png",
    "images/hmny-lightning.png",
    "images/hmny-lightning@2x.png",
    "images/hmny-create-wallet.png",
    "images/hmny-restore-wallet-from-hardware.png",
    "images/hmny-open-wallet-from-file.png",
    "images/hmny-restore-wallet.png",
    "images/hmny-warning.png",
    "images/hmny-warning@2x.png",
    "images/hmny-busy-indicator.png",
    "images/hmny-busy-indicator@2x.png",
    "images/hmny-logo.png",
    "images/hmny-splash.png",
]
for entry in new_entries:
    tag = f"<file>{entry}</file>"
    if tag not in t:
        t = t.replace("<file>images/world-flags-globe.png</file>", f"<file>images/world-flags-globe.png</file>\n        {tag}", 1)
qrc.write_text(t, encoding="utf-8")

# --- safe QML string branding ---
def brand_qml_user_strings(txt: str) -> str:
    txt = txt.replace("Monero GUI", "HashmonkeyCoin Wallet")
    txt = txt.replace("Monero Wallet", "HashmonkeyCoin Wallet")
    txt = txt.replace("monero://", "hmny://")
    txt = re.sub(
        r'qsTr\("([^"]*)"\)',
        lambda m: 'qsTr("' + m.group(1).replace("Monero", "HashmonkeyCoin").replace("XMR", "HMNY") + '")',
        txt,
    )
    txt = re.sub(
        r"qsTr\('([^']*)'\)",
        lambda m: "qsTr('" + m.group(1).replace("Monero", "HashmonkeyCoin").replace("XMR", "HMNY") + "')",
        txt,
    )
    return txt

for p in ROOT.rglob("*.qml"):
    if "/hashmonkey-core/" in str(p).replace("\\", "/"):
        continue
    txt = p.read_text(encoding="utf-8")
    orig = txt
    txt = brand_qml_user_strings(txt)
    if txt != orig:
        p.write_text(txt, encoding="utf-8")

print("HMNY branding assets applied")
