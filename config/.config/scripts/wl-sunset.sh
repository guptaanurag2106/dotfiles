#!/usr/bin/env bash

wlsunset -l 12.9 -L 77.6 &

while true; do
    swaymsg -t subscribe '["window"]' | jq 'select(.change).container | if (.app_id == "org.mozilla.firefox" or .app_id == "microsoft-edge") then halt_error(127 - .fullscreen_mode) else halt end' > /dev/null 2>&1
    return_code=$?
    echo "$return_code"
    if [ $return_code -eq 126 ]; then
        killall -9 wlsunset
    else
        if pgrep -f "wlsunset" > /dev/null; then
            :
        else
            # CONTENT=$(curl -s http://ip-api.com/json/)
            # longitude=$(echo $CONTENT | jq .lon)
            # latitude=$(echo $CONTENT | jq .lat)
            wlsunset -l 12.9 -L 77.6 &
        fi
    fi
    sleep 1
done
