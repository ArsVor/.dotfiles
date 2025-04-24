#!/bin/zsh

current_group=$(qtile cmd-obj -o group -f info | rg "^\s*'name':" | rg -v 'floating_info')
weather_group=$(wmctrl -lG | rg Weather | awk '{print $2}')

if [[ $weather_group ]]; then
    ((weather_group++))
fi

if [[ $weather_group ]] && [[ $current_group =~ $weather_group ]]; then
    killall -9 gnome-weather
else
    killall -9 gnome-weather
    qtile run-cmd -f gnome-weather
fi
