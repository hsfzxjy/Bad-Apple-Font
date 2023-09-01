#!/bin/bash

HERE=$(cd $(dirname "$0") && pwd)

export LD_PRELOAD="$HERE/07_HarfBuzz/harfbuzz/build/src/libharfbuzz.so.0 $HERE/07_HarfBuzz/wasm-micro-runtime/build/libiwasm.so"

exec "$@"
