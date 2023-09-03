#!/bin/bash

source "$(dirname $0)/../util.sh"

export APPIMAGELAUNCHER_DISABLE=1

../04_Make_Font/fontforge -lang=py -c 'import fontforge;\
  font=fontforge.open(argv[1]);\
  font.generate(argv[2])' \
    "$PWD/../04_Make_Font/generated.sfd" "$PWD/BadApple.ttf" || exit 1

cd ../06_HarfBuzz/harfbuzz/

python3 src/addTable.py \
    ../../07_Install_Font/BadApple.ttf \
    ../../BadApple_WASM.ttf \
    ../../05_WASM/pkg/bad_apple_shaper_bg.wasm || exit 1

cd ../..

DEST="$HOME/.local/share/fonts/"

echo "Installing BadApple_WASM.ttf to $DEST..."
rm -f "$DEST/BadApple_WASM.ttf"
ln -s $PWD/BadApple_WASM.ttf "$DEST"
echo "Font Installed."