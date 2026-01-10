#!/bin/bash

current_volume=$(wpctl get-volume @DEFAULT_SINK@)

volume=$(echo $current_volume | cut -f 2 -d " " | sed 's/%//g' | sed 's/\.//g')

if [[ $current_volume == *"MUTED"* ]]; then
    echo " ---"
    exit 0
fi

if ! [[ "$volume" =~ ^[0-9]+$ ]]; then
    echo "Error: Volume is not a valid number."
    exit 1
fi

volume=$(echo "$volume" | sed 's/^0*//')
if [ "$volume" -gt 99 ]; then
    echo " $volume%"
elif [ "$volume" -gt 65 ]; then
    echo " $volume%"
elif [ "$volume" -gt 30 ]; then
    echo " $volume%"
elif [ "$volume" -gt 10 ]; then
    echo " $volume%"
elif [ "$volume" -gt 0 ]; then
    echo " $volume%"
else
    echo " ---"
fi
