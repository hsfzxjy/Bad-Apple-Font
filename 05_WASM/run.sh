#!/bin/bash

source "$(dirname $0)/../util.sh"

if !builtin command -v wasm-pack; then
    cargo install wasm-pack || exit 1
fi
if [ ! -z "$(rustup toolchain list | grep nightly)" ]; then
    rustup install nightly || exit 1
else
    echo "Rust Nightly installed."
fi
rustup run nightly $(which wasm-pack) build || exit 1
