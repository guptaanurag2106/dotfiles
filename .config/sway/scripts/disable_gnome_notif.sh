#!/bin/bash

if [ "$XDG_SESSION_DESKTOP" = "sway" ]; then
    pkill -f gnome-shell
    # dunst &
else
    pkill dunst
    gnome-shell --replace &
fi
