#!/bin/bash

HERE=$(cd $(dirname "$0") && pwd)

export LD_PRELOAD="$HERE/06_HarfBuzz/harfbuzz/build/src/libharfbuzz.so.0 $HERE/06_HarfBuzz/wasm-micro-runtime/build/libiwasm.so"

exec "$@"
