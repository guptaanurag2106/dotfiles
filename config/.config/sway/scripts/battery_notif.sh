#!/bin/bash

NOTIFICATION_FULL=0

while true; do
    # Battery status check
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT1/status)
    # Battery capacity check
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)

    if [[ $BATTERY_STATUS == "Discharging" ]]; then
        NOTIFICATION_FULL=0
        if [[ $BATTERY_LEVEL -le 5 ]]; then
            notify-send -u critical -t 10000 "Battery critical!" "${BATTERY_LEVEL}%"
            sleep 60
        elif [[ $BATTERY_LEVEL -le 20 ]]; then
            notify-send -u critical -t 5000 "Battery low!" "${BATTERY_LEVEL}%"
            sleep 600
        fi
    elif [[ $BATTERY_STATUS == "Charging" && $BATTERY_LEVEL -eq 100 && $NOTIFICATION_FULL -eq 0 ]]; then
        notify-send -u normal -t 5000 "Battery full!" "${BATTERY_LEVEL}%"
        NOTIFICATION_FULL=1
    fi

    sleep 180
done
