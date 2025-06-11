#!/bin/sh


CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | rofi -dmenu -i)

case "$CHOSEN" in
	"Lock") swaylock -f -c 000000 ;;
	"Suspend") systemctl suspend ;;
	"Reboot") systemctl reboot ;;
	"Shutdown") systemctl -i poweroff ;;
	"Log Out") swaymsg exit ;;
	*) exit 1 ;;
esac
