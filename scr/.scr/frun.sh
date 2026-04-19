#!/bin/bash

fuzzel --list-executables-in-path --hide-before-typing --match-mode=exact --lines=1 --background=00000000 --selection-color=2d353bff --no-icon --selection-text-color=00000000 --horizontal-pad=10 --cache=/dev/null --anchor=top-left --y-margin=-45 --x-margin=250 --width=30 --input-color=d3c6aaff --prompt-color=d3c6aaff --border-color=00000000 --dmenu | xargs -r sh -c
