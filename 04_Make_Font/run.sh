#!/bin/bash

source "$(dirname $0)/../util.sh"

download "https://raw.githubusercontent.com/Automattic/node-canvas/master/examples/pfennigFont/Pfennig.sfd" \
    "base.sfd.sha256" \
    "base.sfd"

mkdir svgs -p

export APPIMAGELAUNCHER_DISABLE=1

download "https://github.com/fontforge/fontforge/releases/download/20230101/FontForge-2023-01-01-a1dad3e-x86_64.AppImage" \
    "fontforge.sha256" \
    "fontforge"
chmod +x fontforge
export PATH=$PWD:$PATH

dryrunable 'fontforge-svg-importer/fontforge-svg-importer "$PWD/base.sfd" "$PWD/generated.sfd" $PWD/../03_Vectorization/svgs/*.svg'

echo "SVG files imported."
