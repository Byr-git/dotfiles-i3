#!/bin/bash

PART="/"
STATE_FILE="/tmp/i3blocks_disk_mode"

COLOR1="#FFEECC"
COLOR2="#ffffff"

# Leer estado (0 = completo, 1 = solo free)
mode=0
[[ -f "$STATE_FILE" ]] && read -r mode < "$STATE_FILE"

if [[ "$BLOCK_BUTTON" == "1" ]]; then
    mode=$((1 - mode))
    echo "$mode" > "$STATE_FILE"
fi

read total used free <<< $(df -Pk "$PART" | awk 'NR==2 {print $2, $3, $4}')

free_gb=$(awk -v kb="$free" 'BEGIN {printf "%.1f", kb/1048576}')
percent=$(( free * 100 / total ))

# Construir contenido dinámico
if [[ "$mode" == "1" ]]; then
    content="${free_gb}G  ${percent}%"
else
    content="${free_gb}G"
fi

printf "<span fgcolor='#000000' size='10000'></span>\
<span fgcolor='$COLOR2'></span>\
<span fgcolor='$COLOR1' weight='bold'>  %s</span>\
<span fgcolor='#000000' size='10000'></span>\n" "$content"

