#!/bin/bash
# Sync hashmonkey-core sources into the GUI monero tree, rebuild Linux + Windows, write manifest.
set -euo pipefail

ROOT="${HMNY_ROOT:-/home/monkeynas/hashmonkey}"
CORE="$ROOT/src/hashmonkey-core"
MONERO="$ROOT/src/hashmonkey-gui/monero"
BUILD="$ROOT/src/hashmonkey-gui/build/release"
WIN_BUILD="$ROOT/src/hashmonkey-gui/build/x86_64-w64-mingw32/release"
REL="$ROOT/release-packages"
STAMP="$(date +%Y%m%d-%H%M%S)"
MANIFEST="$REL/manifest-$STAMP.txt"

sync_file() {
  local rel="$1"
  if [ ! -f "$CORE/$rel" ]; then
    echo "missing: $CORE/$rel"
    return 1
  fi
  cp "$CORE/$rel" "$MONERO/$rel"
}

echo "=== Sync core -> monero $(date -Is) ==="
sync_file src/cryptonote_core/cryptonote_core.cpp
sync_file src/rpc/core_rpc_server.cpp
sync_file src/p2p/net_node.inl
sync_file src/cryptonote_basic/miner.cpp

mkdir -p "$REL/linux" "$REL/windows"
echo "=== Linux daemon ==="
cd "$BUILD"
make -j"$(nproc)" daemon
cp -f bin/hashmonkeyd bin/hashmonkey-wallet-cli bin/hashmonkey-wallet-rpc "$REL/linux/"

if [ -d "$WIN_BUILD" ]; then
  echo "=== Windows cross (daemon + wallet-cli) ==="
  cd "$WIN_BUILD"
  make -j"$(nproc)" daemon 2>/dev/null || make -j"$(nproc)" 2>/dev/null || true
  if [ -f bin/hashmonkeyd.exe ]; then
    cp -f bin/hashmonkeyd.exe bin/hashmonkey-wallet-cli.exe "$REL/windows/" 2>/dev/null || cp -f bin/hashmonkeyd.exe "$REL/windows/"
  fi
fi

# Legacy folder name used by desktop zip layout
mkdir -p "$ROOT/release-windows"
cp -f "$REL/windows/"*.exe "$ROOT/release-windows/" 2>/dev/null || true

{
  echo "# HMNY build manifest $STAMP"
  echo "built_at=$(date -Is)"
  (cd "$REL/linux" && sha256sum hashmonkeyd hashmonkey-wallet-cli hashmonkey-wallet-rpc 2>/dev/null) || true
  (cd "$REL/windows" && sha256sum *.exe 2>/dev/null) || true
  "$BUILD/bin/hashmonkeyd" --version 2>&1 | head -1 || true
} | tee "$MANIFEST" "$REL/manifest-latest.txt"

echo "=== Done: $MANIFEST ==="
