#!/bin/sh


CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | rofi -dmenu -i)

case "$CHOSEN" in
	"Lock") swaylock ;;
	"Suspend") systemctl suspend ;;
	"Reboot") reboot ;;
	"Shutdown") poweroff ;;
	"Log Out") swaymsg exit ;;
	*) exit 1 ;;
esac
