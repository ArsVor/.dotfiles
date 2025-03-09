#!/usr/bin/env bash

if [[ "$DESKTOP_SESSION" = "qtile" ]]; then
    qtile cmd-obj -o cmd -f shutdown
elif [[ "$DESKTOP_SESSION" = "GNOME" ]]; then
    gnome-session-quit --force
fi
