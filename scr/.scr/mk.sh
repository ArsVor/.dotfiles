#!/bin/bash

TARGET="$1"
IS_FILE=1

if ! [[ $TARGET ]]; then
    echo "WARNING: nothing to do";
    exit 0
fi

[[ $TARGET =~ \/$ ]] && IS_FILE=0;

if [[ $IS_FILE == 1 ]]; then
    DIRNAME=$(dirname "$TARGET")

    if ! [[ -d $DIRNAME ]]; then
        mkdir -p $DIRNAME
    fi

    touch $TARGET
else
    mkdir -p $TARGET
fi
