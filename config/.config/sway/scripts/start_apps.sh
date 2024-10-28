#! /usr/bin/env bash

swaymsg workspace 1
firefox &

# Open Terminal on workspace 2
swaymsg workspace 2
alacritty &

# Open Firefox Incognito on workspace 4
swaymsg workspace 4
firefox --private-window &

# Open VSCode on workspace 5
swaymsg workspace 5
codium &

# Return to workspace 1 (optional)
swaymsg workspace 1
