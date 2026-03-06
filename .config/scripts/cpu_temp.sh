#!/bin/bash

# Get CPU temperature using tlp-stat -t
# temp=$(tlp-stat -t | grep "CPU temp" | awk '{print $4}')
temp=$(sensors -j | jq '[.["coretemp-isa-0000"]["Core 0"]["temp2_input"], .["coretemp-isa-0000"]["Core 1"]["temp3_input"], .["coretemp-isa-0000"]["Core 2"]["temp4_input"], .["coretemp-isa-0000"]["Core 3"]["temp5_input"]] | add / length | (.*10 |round / 10)')

# Output temperature in Waybar format
echo "{\"text\": \"$temp°C\"}"
# echo "{\"text\": \" 🌡️$temp°C\"}"

