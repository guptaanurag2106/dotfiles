#!/bin/sh
blueman-applet &
nm-applet --indicator &
pkill flameshot && flameshot &
lxpolkit &
