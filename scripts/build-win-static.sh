#!/usr/bin/env bash
set -euo pipefail
export MSYSTEM=MINGW64
export CHERE_INVOKING=1
LOG="/d/My_Blockchain/scripts/build-win-static.log"
exec > >(tee "$LOG") 2>&1
echo "=== HMNY Windows STATIC build $(date -Is) ==="

# Qt static + deps for release-static-win64 (like official Monero release)
pacman -S --needed --noconfirm \
  mingw-w64-x86_64-qt5-static \
  mingw-w64-x86_64-qt5-declarative \
  mingw-w64-x86_64-qt5-svg \
  mingw-w64-x86_64-qt5-graphicaleffects \
  mingw-w64-x86_64-qt5-translations \
  mingw-w64-x86_64-libgcrypt \
  mingw-w64-x86_64-protobuf-c \
  mingw-w64-x86_64-libusb \
  mingw-w64-x86_64-angleproject \
  2>&1 | tail -8

/c/Users/Thestabner/AppData/Local/Programs/Python/Python310/python.exe /d/My_Blockchain/scripts/apply_hmny_brand.py

# --- Core (static) ---
cd /d/My_Blockchain/hashmonkey-core
export USE_DEVICE_TREZOR=OFF
rm -rf build/MINGW64_NT-10.0-22631/master/release 2>/dev/null || true
make release-static -j$(nproc)
echo "Core static bin:"
ls -la build/MINGW64_NT-10.0-22631/master/release/bin/hashmonkey*.exe 2>/dev/null || \
ls -la build/release/bin/hashmonkey*.exe

# --- GUI (static win64) ---
cd /d/My_Blockchain/hashmonkey-gui
export DEV_MODE=ON
export MANUAL_SUBMODULES=1
export USE_DEVICE_TREZOR=OFF
rm -rf build/release
make release-static-win64 -j$(nproc)

GUI_BIN="/d/My_Blockchain/hashmonkey-gui/build/release/bin/hashmonkey-wallet-gui.exe"
echo "GUI static:"
ls -la "$GUI_BIN"
echo "DLL dependencies (should be Windows system only):"
objdump -p "$GUI_BIN" | grep 'DLL Name' || true

echo "=== STATIC build done $(date -Is) ==="
