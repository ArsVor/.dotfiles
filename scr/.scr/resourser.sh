#!/bin/bash
FLAG=$1

killall resourser &

exec kitty --title "resourser" --class "resourser" --override="background_opacity 1" \
    --override "initial_window_width 550" --override "initial_window_height 430" \
    --override "remember_window_size  no" --position 1360x5 \
    -e ~/projects/resourser/target/release/resourser "$FLAG"
