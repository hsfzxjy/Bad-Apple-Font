#!/bin/bash

source "$(dirname $0)/../util.sh"

mkdir -p bmps

dryrunable ffmpeg -i ../01_Download_Video/badapple.mp4 -vf fps=30 bmps/%d.bmp || exit 1

echo "Frames extracted."
