#!/usr/bin/env bash

wait_for_window() {
  local criteria="$1" timeout="${2:-100}" elapsed=0
  while [ "$elapsed" -lt "$timeout" ]; do
    if swaymsg -t get_tree | jq -r '.. | .app_id?, .name? | select(.)' 2>/dev/null | grep -i -m1 -E "$criteria" >/dev/null; then
      return 0
    fi
    sleep 0.15
    elapsed=$((elapsed + 1))
  done
  return 1
}

nohup firefox > /dev/null 2>&1 &
nohup emacs > /dev/null 2>&1 &

if wait_for_window "firefox"; then
  swaymsg '[app_id="firefox"] move window to workspace 1'
fi

if wait_for_window "emacs"; then
  swaymsg '[app_id="emacs"] move window to workspace 2'
fi

swaymsg workspace 1
