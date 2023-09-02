#!/bin/bash

source "$(dirname $0)/../util.sh"

cargo install wasm-pack
rustup install nightly
rustup run nightly $(which wasm-pack) build
