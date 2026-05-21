#!/bin/bash
set -euo pipefail
ROOT="${1:-/home/monkeynas/hashmonkey/src/hashmonkey-core}"
LOG="${2:-/home/monkeynas/hashmonkey/build-win-cross.log}"
exec > >(tee -a "$LOG") 2>&1
echo "=== HMNY Windows cross build started $(date -Is) ==="
cd "$ROOT"
export USE_DEVICE_TREZOR=OFF
make depends target=x86_64-w64-mingw32 -j16
echo "=== Windows cross build finished $(date -Is) ==="
ls -la build/x86_64-w64-mingw32/release/bin/ | head -20
