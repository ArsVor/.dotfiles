#!/bin/bash

niri msg pick-color | rg Hex | awk '{ print $2 }' | wl-copy
