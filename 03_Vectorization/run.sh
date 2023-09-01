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

function unicode() {
    python3 -c 'print(chr(0xF0000 + int(__import__("sys").argv[1])),end="")' $1
}

dryrunable 'for i in $(seq 1 6573); do
    echo "Processing ${i}.bmp..."
    "$POTRACE" -s ../02_Extract_Frames/bmps/${i}.bmp -o "svgs/$(unicode $i).svg"
done'

echo "Vectorization done."
