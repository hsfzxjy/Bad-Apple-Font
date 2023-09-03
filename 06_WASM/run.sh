#!/bin/bash

source "$(dirname $0)/../util.sh"

cargo install wasm-pack || exit 1
rustup install nightly || exit 1
rustup run nightly $(which wasm-pack) build || exit 1
