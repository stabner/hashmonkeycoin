#!/usr/bin/env bash
set -euo pipefail
export MSYSTEM=MINGW64
export CHERE_INVOKING=1
export PKG_CONFIG_PATH="/mingw64/qt5-static/lib/pkgconfig:/mingw64/lib/pkgconfig"
export CMAKE_PREFIX_PATH="/mingw64/qt5-static"
export DEV_MODE=ON
export MANUAL_SUBMODULES=1
export USE_DEVICE_TREZOR=OFF

GUI="/d/My_Blockchain/hashmonkey-gui"
CORE_BIN="/d/My_Blockchain/hashmonkey-core/build/MINGW64_NT-10.0-22631/master/release/bin"
LOG="/d/My_Blockchain/scripts/build-gui-static-win64.log"
exec > >(tee "$LOG") 2>&1
echo "=== HMNY GUI static win64 $(date -Is) ==="
echo "Qt5Qml prefix: $(pkg-config --variable=prefix Qt5Qml 2>/dev/null || echo missing)"

mkdir -p "$GUI/hashmonkey-core/build/MINGW64_NT-10.0-22631/master/release/bin"
cp -f "$CORE_BIN"/hashmonkeyd.exe "$CORE_BIN"/hashmonkey-wallet-cli.exe "$CORE_BIN"/hashmonkey-wallet-rpc.exe \
  "$GUI/hashmonkey-core/build/MINGW64_NT-10.0-22631/master/release/bin/" 2>/dev/null || true

cd "$GUI"
rm -rf build/release
mkdir -p build/release
cd build/release
cmake -G "MSYS Makefiles" \
  -D STATIC=ON \
  -D DEV_MODE=ON \
  -D MANUAL_SUBMODULES=1 \
  -D USE_DEVICE_TREZOR=OFF \
  -D WITH_UPDATER=OFF \
  -D ARCH="x86-64" \
  -D BUILD_64=ON \
  -D CMAKE_BUILD_TYPE=Release \
  -D BUILD_TAG="win-x64" \
  -D CMAKE_TOOLCHAIN_FILE=../../cmake/64-bit-toolchain.cmake \
  -D MSYS2_FOLDER="$(cd "${MINGW_PREFIX}/.." && pwd -W)" \
  -D MINGW=ON \
  -D CMAKE_PREFIX_PATH="/mingw64/qt5-static" \
  ../..

make hashmonkey-wallet-gui -j$(nproc)

EXE="../bin/hashmonkey-wallet-gui.exe"
ls -la "$EXE"
echo "DLL deps:"
objdump -p "$EXE" | grep 'DLL Name' || true
echo "=== done $(date -Is) ==="
