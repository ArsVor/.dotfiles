#!/bin/bash

exec kitty --title "btop-float" --class "btop-float" --override="background_opacity 0.3" \
    --override "initial_window_width 1900" --override "initial_window_height 1000" \
    --override "remember_window_size  no" -e btop
