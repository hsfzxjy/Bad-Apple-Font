#!/bin/bash

source "$(dirname $0)/../util.sh"

export APPIMAGELAUNCHER_DISABLE=1

../04_Make_Font/fontforge -lang=py -c 'import fontforge;\
  font=fontforge.open(argv[1]);\
  font.generate(argv[2])' \
    "$PWD/../04_Make_Font/generated.sfd" "$PWD/BadApple.ttf"
