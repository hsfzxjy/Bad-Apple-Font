#!/bin/bash

HERE=$(cd $(dirname $0) && pwd)
cd "$HERE"

function checksum() {
    sha256sum -c "$1"
}

function download() {
    builtin local url="$1" sumfile="$2" file="$3"
    if ! checksum "$sumfile" &>/dev/null; then
        wget "$url" -O "$file"
    fi
    if ! checksum "$sumfile"; then
        echo "Fail to download $file!"
        exit 1
    fi
}

function download_ex() {
    builtin local action="$1" sumfile="$2"
    if ! checksum "$sumfile" &>/dev/null; then
        builtin eval "$action"
    fi
    if ! checksum "$sumfile"; then
        echo "Fail to satisfy $sumfile!"
        exit 1
    fi
}

function dryrunable() {
    if [ -z $DRYRUN ]; then
        builtin eval "$@"
    fi
}

function available() {
    builtin local TRASH
    TRASH=$(builtin command -v "$1")
    builtin return $?
}
