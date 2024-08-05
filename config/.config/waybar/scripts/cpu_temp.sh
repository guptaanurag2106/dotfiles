#!/bin/bash

# Get CPU temperature using tlp-stat -t
temp=$(tlp-stat -t | grep "CPU temp" | awk '{print $4}')

# Output temperature in Waybar format
# echo "{\"text\": \" $temp°C\"}"
echo "{\"text\": \"$temp°C\"}"

