#!/bin/zsh

kitty -e pikaur -Syu && qtile cmd-obj -o widget checkupdates -f force_update
