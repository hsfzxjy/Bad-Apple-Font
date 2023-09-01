#!/bin/bash

export DRYRUN=

function usage() {
    echo usage
}

while getopts "n" o; do
    case "${o}" in
    n)
        export DRYRUN=1
        ;;
    *)
        usage
        ;;
    esac
done

for entry in ??_*/run.sh; do
    echo "======>"
    echo "======> Running $entry..."
    "$entry" || exit 1
done

echo "ALL DONE!!!"
