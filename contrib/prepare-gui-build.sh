#!/usr/bin/env bash
# Sync top-level hashmonkey-core into hashmonkey-gui/hashmonkey-core before cmake.
# Required because hashmonkey-gui/hashmonkey-core/ is gitignored (build tree only).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORE="$ROOT/hashmonkey-core"
GUI="$ROOT/hashmonkey-gui"
DEST="$GUI/hashmonkey-core"

if [[ ! -f "$CORE/CMakeLists.txt" ]]; then
  echo "ERROR: missing $CORE/CMakeLists.txt"
  exit 1
fi
if [[ ! -f "$GUI/CMakeLists.txt" ]]; then
  echo "ERROR: missing $GUI/CMakeLists.txt"
  exit 1
fi

echo "Syncing $CORE -> $DEST"
mkdir -p "$DEST"
rsync -a --delete \
  --exclude build --exclude .git \
  "$CORE/" "$DEST/"

echo ""
echo "Ready to build GUI:"
echo "  cd $GUI"
echo "  mkdir -p build/release && cd build/release"
echo "  cmake -DCMAKE_BUILD_TYPE=Release -DMANUAL_SUBMODULES=1 -DWITH_UPDATER=OFF ../.."
echo "  make -j\"\$(nproc)\" hashmonkey-wallet-gui"
echo ""
echo "Ship hashmonkeyd next to the GUI for full-node mode (build core separately)."
