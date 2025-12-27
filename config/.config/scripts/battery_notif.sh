#!/bin/sh

# process_count=$(pgrep "battery_notif" | wc -l)
process_count=$(pgrep -f "$(basename "$0")" | wc -l)
# echo $process_count

if [ "$process_count" -gt 2 ]; then
    exit 0
fi

NOTIFICATION_FULL=0

while true; do
    # Battery status check
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT1/status)
    # Battery capacity check
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)

    if [[ $BATTERY_STATUS == "Discharging" ]]; then
        NOTIFICATION_FULL=0
        if [[ $BATTERY_LEVEL -le 5 ]]; then
            notify-send --app-name="Battery" -i battery-000 -u critical -t 10000 "Battery critical!" "${BATTERY_LEVEL}%"
            sleep 15
        elif [[ $BATTERY_LEVEL -le 20 ]]; then
            notify-send --app-name="Battery" -i battery-020 -u normal -t 5000 "Battery low!" "${BATTERY_LEVEL}%"
            sleep 30
        fi

    elif { [[ $BATTERY_STATUS == "Charging" || $BATTERY_STATUS == "Full" ]] && [[ $BATTERY_LEVEL -eq 100 ]] && [[ $NOTIFICATION_FULL -eq 0 ]]; }; then
        notify-send --app-name="Battery" -i battery-100 -u low -t 5000 "Battery full!" "${BATTERY_LEVEL}%"
        NOTIFICATION_FULL=1
        sleep 30
    else
        sleep 30
    fi

done
