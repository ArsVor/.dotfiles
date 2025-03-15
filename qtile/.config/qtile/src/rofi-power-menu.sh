#!/bin/zsh

script_dir=$(realpath "${0:A:h}")
rofi -show power-menu -modi power-menu:$script_dir/rofi-power-menu -theme ~/.local/share/rofi/themes/bluetooth.rasi
