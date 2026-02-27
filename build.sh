#!/usr/bin/env bash
set -euo pipefail

git submodule update --init --recursive
npm install
rm -rf embuild

export EMSDK="$HOME/emsdk"
export EMSDK_NODE_BIN="$EMSDK/node/22.16.0_64bit/bin"
export EMSCRIPTEN="$EMSDK/upstream/emscripten"
export PATH="$EMSDK:$EMSCRIPTEN:$EMSDK_NODE_BIN:$PATH"
export EM_CONFIG="$EMSDK/.emscripten"
export EM_PORTS="$EMSDK/.emscripten_ports"
export EM_CACHE="$EMSDK/.emscripten_cache"
export EMSDK_NODE="$EMSDK_NODE_BIN/node"
export EMCC_WASM_BACKEND=1
export EMCC_SKIP_SANITY_CHECK=1

rm -rf "$EM_CACHE"

mkdir embuild
cd embuild

cmake -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake ..
cmake --build . --parallel "$(nproc)"

cd ..
node ./replacer.js embuild h264-mp4-encoder.js
# npm run build