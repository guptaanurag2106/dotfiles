#!/bin/sh

set -e

processes=$(ps -U tanz --no-headers -o pid,comm,%cpu,%mem | awk '{printf "%-10s %s  %s %s\n", $1, $2, $3, $4}')

pid_info=$(echo "$processes" | rofi -dmenu -i -p "Select a process to kill")

pid=$(echo "$pid_info" | awk '{print $1}')
command=$(echo "$pid_info" | awk '{$1=""; print $0}' | xargs)

if [ -n "$pid" ]; then
    CHOSEN=$(printf "No\nYes" | rofi -dmenu -i -p "Are you sure you want to kill $command?")
    case "$CHOSEN" in
        "Yes")
            if kill -9 "$pid"; then
                notify-send "Process Killed" "Successfully killed PID: $pid ($command)"
            else
                notify-send "Error" "Failed to kill PID: $pid"
            fi
            ;;
    esac
fi
