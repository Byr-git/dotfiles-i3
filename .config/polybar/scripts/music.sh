#!/bin/bash

CACHE="/tmp/player_cache"
PIDFILE="/tmp/polybar_music.pid"
MAX=45

COLOR1="#F0C674"
COLOR2="#C5C8C6"

echo $$ > "$PIDFILE"

print_status() {
    DATA=$(playerctl metadata --format '{{status}}|{{artist}}|{{title}}' 2>/dev/null)

    if [[ -z "$DATA" ]]; then
        echo "%{F$COLOR1} %{F$COLOR1}󰝚  %{F$COLOR2}󰇘 %{F$COLOR1}"
        return
    fi

    if [[ "$DATA" != "$(cat "$CACHE" 2>/dev/null)" ]]; then
        echo "$DATA" > "$CACHE"
    fi

    IFS="|" read -r status artist title <<< "$DATA"

    if [[ "$status" == "Playing" ]]; then
        TEXT="$artist - $title"
        [[ ${#TEXT} -gt $MAX ]] && TEXT="${TEXT:0:$MAX}…"

        echo "%{F$COLOR1} %{F$COLOR1}󰝚  %{F$COLOR2}$TEXT %{F$COLOR1}"

    elif [[ "$status" == "Paused" ]]; then
        echo "%{F$COLOR1} %{F$COLOR1} %{F$COLOR2}$artist - $title %{F$COLOR1}"

    else
        echo "%{F$COLOR1} %{F$COLOR1}󰝚  %{F$COLOR2}󰇘 %{F$COLOR1}"
    fi
}

trap "print_status" USR1

if [[ "$1" == "left" ]]; then
    playerctl play-pause
    kill -USR1 "$(cat $PIDFILE 2>/dev/null)"
    exit
fi

print_status

playerctl -F metadata --format '{{status}}|{{artist}}|{{title}}' 2>/dev/null | while read -r _; do
    print_status
done
