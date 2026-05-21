#!/bin/bash
set -euo pipefail
GUI=/home/monkeynas/hashmonkey/src/hashmonkey-gui
LOG=/home/monkeynas/hashmonkey/docker-gui-build.log
exec > >(tee -a "$LOG") 2>&1
echo "=== GUI static build $(date -Is) ==="
sudo rm -rf "$GUI/build/x86_64-w64-mingw32" 2>/dev/null || rm -rf "$GUI/build/x86_64-w64-mingw32" 2>/dev/null || true
# Mount as /monero-gui so existing CMakeCache paths stay valid; symlink core for cache.
ln -sfn hashmonkey-core "$GUI/monero"
docker run --rm -v "$GUI:/monero-gui" hmny:build-env-windows rm -rf /monero-gui/build/x86_64-w64-mingw32
docker run --rm \
  -v "$GUI:/monero-gui" \
  -w /monero-gui/build/x86_64-w64-mingw32/release \
  hmny:build-env-windows \
  sh -c 'git config --global --add safe.directory /monero-gui; git config --global --add safe.directory /monero-gui/hashmonkey-core; \
    mkdir -p /monero-gui/build/x86_64-w64-mingw32/release && cd /monero-gui/build/x86_64-w64-mingw32/release && \
    cmake -S /monero-gui -B . -D STATIC=ON -D DEV_MODE=ON -D MANUAL_SUBMODULES=1 -D BUILD_TAG=win-x64 -D CMAKE_BUILD_TYPE=Release -D USE_DEVICE_TREZOR=OFF \
      -D CMAKE_TOOLCHAIN_FILE=/depends/x86_64-w64-mingw32/share/toolchain.cmake && \
    make -j16 hashmonkey-wallet-gui daemon simplewallet wallet_rpc \
      blockchain_import blockchain_export blockchain_ancestry blockchain_depth blockchain_stats blockchain_usage \
      blockchain_prune blockchain_prune_known_spent_data blockchain_blackball gen_ssl_cert gen_multisig'
echo "=== done $(date -Is) ==="
ls -la "$GUI/build/x86_64-w64-mingw32/release/bin/" 2>/dev/null || true
