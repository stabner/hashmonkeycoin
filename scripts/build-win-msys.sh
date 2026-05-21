#!/usr/bin/env bash
set -euo pipefail
export MSYSTEM=MINGW64
export CHERE_INVOKING=1
ROOT="/d/My_Blockchain/hashmonkey-core"
LOG="/d/My_Blockchain/scripts/build-win-msys.log"
exec > >(tee -a "$LOG") 2>&1
echo "=== HMNY MSYS2 Windows build $(date -Is) ==="
cd "$ROOT"
export USE_DEVICE_TREZOR=OFF
if [ -d .git ]; then
  git submodule update --init --recursive || true
fi
make release-static -j$(nproc)
echo "=== Done $(date -Is) ==="
ls -la build/release/bin/ | head -25
