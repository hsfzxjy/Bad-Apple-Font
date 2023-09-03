#!/bin/bash

source "$(dirname $0)/../util.sh"

download "https://github.com/mesonbuild/meson/releases/download/1.2.1/meson-1.2.1.tar.gz" "meson-1.2.1.tar.gz.sha256" "meson-1.2.1.tar.gz"
tar xzvf "meson-1.2.1.tar.gz"

MESON="$PWD/meson-1.2.1/meson.py"

cd wasm-micro-runtime

cmake -B build -DWAMR_BUILD_REF_TYPES=1 -DWAMR_BUILD_FAST_JIT=1 || exit 1
cmake --build build --parallel || exit 1

cd ..

export CPLUS_INCLUDE_PATH=$PWD/wasm-micro-runtime/core/iwasm/include/
export LIBRARY_PATH=$PWD/wasm-micro-runtime/build/
export LD_LIBRARY_PATH="$LIBRARY_PATH"

cd harfbuzz

"$MESON" setup build -Dwasm=enabled || exit 1
"$MESON" compile -C build || exit 1
