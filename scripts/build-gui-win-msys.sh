#!/usr/bin/env bash
set -euo pipefail
export MSYSTEM=MINGW64
export CHERE_INVOKING=1
GUI="/d/My_Blockchain/hashmonkey-gui"
CORE_BIN="/d/My_Blockchain/hashmonkey-core/build/MINGW64_NT-10.0-22631/master/release/bin"
LOG="/d/My_Blockchain/scripts/build-gui-win-msys.log"
exec > >(tee -a "$LOG") 2>&1
echo "=== HMNY GUI Windows build $(date -Is) ==="

pacman -S --needed --noconfirm \
  mingw-w64-x86_64-qt5 \
  mingw-w64-x86_64-protobuf-c \
  mingw-w64-x86_64-libusb \
  mingw-w64-x86_64-libgcrypt \
  mingw-w64-x86_64-pcre \
  mingw-w64-x86_64-angleproject \
  2>&1 | tail -5

cd "$GUI"

CORE_BUILD="$GUI/hashmonkey-core/build/MINGW64_NT-10.0-22631/master/release"
mkdir -p "$CORE_BUILD/bin"
cp -f "$CORE_BIN"/hashmonkeyd.exe "$CORE_BIN"/hashmonkey-wallet-cli.exe "$CORE_BIN"/hashmonkey-wallet-rpc.exe "$CORE_BUILD/bin/"

rm -rf build/release
mkdir -p build/release
cd build/release
cmake -G "MSYS Makefiles" \
  -D STATIC=OFF \
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
  ../..

make -j$(nproc)
make deploy

echo "=== GUI build done $(date -Is) ==="
ls -la bin/hashmonkey-wallet-gui.exe
