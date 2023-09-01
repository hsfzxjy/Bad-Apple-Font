#!/bin/bash

source "$(dirname $0)/../util.sh"

cargo install wasm-pack

wasm-pack build
