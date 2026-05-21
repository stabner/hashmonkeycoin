#!/bin/bash
# Windows static GUI via Dockerfile.windows
set -euo pipefail
ROOT="${HMNY_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
CORE="$ROOT/hashmonkey-core"
GUI="$ROOT/hashmonkey-gui"
LOG="${HMNY_LOG:-$ROOT/docker-hmny-win-build.log}"
IMAGE="${HMNY_DOCKER_IMAGE:-hmny:build-env-windows}"
exec > >(tee -a "$LOG") 2>&1

echo "=== HMNY Windows Docker pipeline $(date -Is) ==="

export MONERO_GUI_ROOT="$GUI"
export HMNY_LOGO_DIR="$ROOT/logo"
python3 "$ROOT/scripts/apply_hmny_brand.py" || { pip3 install pillow -q --user; python3 "$ROOT/scripts/apply_hmny_brand.py"; }
python3 "$ROOT/scripts/patch_qml_colors.py" "$GUI" || true

rsync -a --delete --exclude build --exclude .git "$CORE/" "$GUI/hashmonkey-core/"

cd "$GUI"
docker build -t "$IMAGE" --build-arg THREADS="${HMNY_BUILD_THREADS:-16}" -f Dockerfile.windows .

docker run --rm -v "$GUI:/hashmonkey-gui" -w /hashmonkey-gui/build/x86_64-w64-mingw32/release "$IMAGE" \
  sh -c 'mkdir -p build/x86_64-w64-mingw32/release && cd build/x86_64-w64-mingw32/release && \
    cmake -D STATIC=ON -D DEV_MODE=ON -D MANUAL_SUBMODULES=1 -D BUILD_TAG=win-x64 \
      -D CMAKE_BUILD_TYPE=Release -D USE_DEVICE_TREZOR=OFF \
      -D CMAKE_TOOLCHAIN_FILE=/depends/x86_64-w64-mingw32/share/toolchain.cmake ../../.. && \
    make -j'"${HMNY_BUILD_THREADS:-16}"' hashmonkey-wallet-gui'

echo "=== Output: $GUI/build/x86_64-w64-mingw32/release/bin/ ==="
ls -la "$GUI/build/x86_64-w64-mingw32/release/bin/"*.exe 2>/dev/null || true
