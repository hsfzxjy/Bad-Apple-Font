#!/bin/bash

source "$(dirname $0)/../util.sh"

download_ex 'wget https://potrace.sourceforge.net/download/1.16/potrace-1.16.linux-x86_64.tar.gz -O potrace-1.16.linux-x86_64.tar.gz && tar xzvf potrace-1.16.linux-x86_64.tar.gz' potrace.sha256

POTRACE=potrace-1.16.linux-x86_64/potrace
chmod +x "$POTRACE"
mkdir -p svgs

if ! available python3; then
    echo "python3 not available!"
    exit 1
fi

dryrunable 'python3 main.py "$POTRACE"'

echo "Vectorization done."
