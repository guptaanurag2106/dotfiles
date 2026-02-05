#!/bin/bash

domains=("youtube.com" "instagram.com")
PID_FILE="/tmp/focus_timer.pid"

auth() {
    response=$(curl -X POST "http://192.168.0.205/api/auth" \
     -H 'accept: application/json' \
     -H 'content-type: application/json' \
     -d '{"password":""}')
    
    SID=$(echo "$response" | jq -r ".session.sid")
    MESSAGE=$(echo "$response" | jq -r ".session.message")
}

countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "Time left: $(date -u -d @$seconds +%H:%M:%S)\r"
        sleep 1
        ((seconds--))
    done
    echo -e "\nTime up!"
}

block(){
    for domain in "${domains[@]}"; do
        curl -X POST "http://192.168.0.205/api/domains/deny/regex" \
            -H 'accept: application/json' \
            -H 'content-type: application/json' \
            -H "sid: $SID" \
            -d "{\"domain\":\"$domain\",\"comment\":\"Calling from focus.sh\",\"groups\":[0],\"enabled\":true}" > /dev/null
    done
    notify-send --app-name="focus" --icon=dialog-information "Block" "Successful"
}

focus() {
    auth
    if [[ "$MESSAGE" != "password correct" ]]; then
         notify-send --app-name="focus" --icon=dialog-information "Authentication" "Failed"
         exit 1
    fi

    sessions=0
    while true; do
        notify-send --app-name="focus" --icon=dialog-information "Start" "40 minutes"
        echo "Starting 40min session"
        block
        countdown 2400

        ((sessions++))
        if [ $sessions -eq 3 ]; then
            notify-send --app-name="focus" --icon=dialog-information "Break" "2 hours"
            echo "2 hour break"
            unfocus
            countdown 7200
            sessions=0
        else
            notify-send --app-name="focus" --icon=dialog-information "Break" "20 minutes"
            echo "20 min break"
            unfocus
            countdown 1200
        fi
    done
}

unfocus() {
    auth
    for domain in "${domains[@]}"; do
        curl -X DELETE "http://192.168.0.205/api/domains/deny/regex/$domain" \
         -H 'accept: application/json' \
         -H "sid: $SID"
    done
    notify-send --app-name="focus" --icon=dialog-information "Unblock" "Successful"
}

cleanup() {
    unfocus
    rm -f "$PID_FILE"
    exit 0
}

trap cleanup SIGINT

# Check if the script is already running
if [ -f "$PID_FILE" ]; then
    echo "Another instance is running. Stopping it..."
    kill -SIGINT $(cat "$PID_FILE")
    wait $(cat "$PID_FILE") 2>/dev/null
    rm "$PID_FILE"
    exit 1
fi

echo $$ > "$PID_FILE"
focus
