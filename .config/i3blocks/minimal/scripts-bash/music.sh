#!/bin/bash

STATE="/tmp/player_show_artist"
CACHE="/tmp/player_cache"
MAX=45

COLOR1="#FFEECC"
COLOR2="#ffffff"

# --------------- CLICKS ---------------
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    playerctl play-pause 2>/dev/null
elif [[ "$BLOCK_BUTTON" == "3" ]]; then
    if [[ -f "$STATE" ]]; then
        rm "$STATE"
    else
        touch "$STATE"
    fi
fi

# --------------- METADATA (UNA SOLA LLAMADA) ---------------
DATA=$(playerctl metadata --format '{{status}}|{{artist}}|{{title}}' 2>/dev/null)

# Si no hay reproductor activo
if [[ -z "$DATA" ]]; then
	printf "<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>\
<span fgcolor='%s' size='8000'>  </span>\
<span fgcolor='%s' weight='bold'>󰇘</span>\
<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>" \
"$COLOR1" "$COLOR2" "$COLOR1" "$COLOR1"
    exit 0
fi

# --------------- CACHE (EVITA TRABAJO SI NADA CAMBIÓ)---------------
if [[ "$DATA" != "$(cat "$CACHE" 2>/dev/null)" ]]; then
    echo "$DATA" > "$CACHE"
fi

IFS="|" read -r status artist title <<< "$DATA"

# --------------- PLAYING ---------------
if [[ "$status" == "Playing" ]]; then

    if [[ ${#title} -gt $MAX ]]; then
        title="${title:0:$MAX}…"
    fi

    if [[ -f "$STATE" ]]; then
        TEXT="$artist - $title"
    else
        TEXT="$title"
    fi

	printf "<span fgcolor='%s' fgalpha='50%%' size='10000'> </span>\
<span fgcolor='%s' size='8000'>  </span>\
<span fgcolor='%s' weight='bold'>%s</span>\
<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>" \
"$COLOR1" "$COLOR2" "$COLOR1" "$TEXT" "$COLOR1"

# --------------- PAUSE ---------------
elif [[ "$status" == "Paused" ]]; then
	printf "<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>\
<span fgcolor='%s' size='8500'> </span>\
<span fgcolor='%s' weight='bold'>Paused</span>\
<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>" \
"$COLOR1" "$COLOR2" "$COLOR1" "$COLOR1"

# --------------- STOP ---------------
else
	printf "<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>\
<span fgcolor='%s' size='8000'>  </span>\
<span fgcolor='%s' weight='bold'>󰇘</span>\
<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>" \
"$COLOR1" "$COLOR2" "$COLOR1" "$COLOR1"
fi
