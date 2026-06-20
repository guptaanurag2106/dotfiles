#!/usr/bin/env bash

LON=77.6
LAT=12.9
TEMP=3800

WLSUNSET_PID=""

start_wlsunset() {
    if [[ -z "$WLSUNSET_PID" ]] || ! kill -0 "$WLSUNSET_PID" 2>/dev/null; then
        wlsunset -l "$LAT" -L "$LON" -t "$TEMP" &
        WLSUNSET_PID=$!
    fi
}

stop_wlsunset() {
    if [[ -n "$WLSUNSET_PID" ]]; then
        kill "$WLSUNSET_PID" 2>/dev/null
        wait "$WLSUNSET_PID" 2>/dev/null
        WLSUNSET_PID=""
    fi
}

cleanup() {
    stop_wlsunset
    exit 0
}

trap cleanup EXIT INT TERM

update() {
    mode=$(
        swaymsg -t get_tree |
        jq -r '
            recurse(.nodes[]?, .floating_nodes[]?)
            | select(.focused == true)
            | .fullscreen_mode
        ' | head -n1
    )

    if [[ "$mode" == "1" ]]; then
        stop_wlsunset
    else
        start_wlsunset
    fi
}

update

swaymsg -m -t subscribe '["window","workspace"]' |
while read -r _; do
    update
done
