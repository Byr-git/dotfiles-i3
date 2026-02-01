#!/bin/bash

STATE="/tmp/player_show_artist"
CACHE="/tmp/player_cache"
MAX=45

# ───────────── CLICKS ─────────────
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    playerctl play-pause 2>/dev/null
elif [[ "$BLOCK_BUTTON" == "3" ]]; then
    if [[ -f "$STATE" ]]; then
        rm "$STATE"
    else
        touch "$STATE"
    fi
fi

# ───────────── METADATA (una sola llamada) ─────────────
DATA=$(playerctl metadata --format '{{status}}|{{artist}}|{{title}}' 2>/dev/null)

# Si no hay reproductor activo
if [[ -z "$DATA" ]]; then
    echo "<span foreground='#0C1240' background='#ffffff'>  </span> \
<span background='#263380'>  󰇘 </span>\
<span foreground='#263380' background='#000000'></span>"
    exit 0
fi

# Cache (evita trabajo si nada cambió)
if [[ "$DATA" != "$(cat "$CACHE" 2>/dev/null)" ]]; then
    echo "$DATA" > "$CACHE"
fi

IFS="|" read -r status artist title <<< "$DATA"

# ───────────── COLORS ─────────────
COLOR1="#0C1240"
COLOR2="#263380"
#COLOR1="#0C1240"

# ───────────── PLAYING ─────────────
if [[ "$status" == "Playing" ]]; then

    if [[ ${#title} -gt $MAX ]]; then
        title="${title:0:$MAX}…"
    fi

    if [[ -f "$STATE" ]]; then
        TEXT="$artist - $title"
    else
        TEXT="$title"
    fi

    echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span foreground='#ffffff' background='$COLOR2'>   Playing 󰐊  </span> \
<span background='$COLOR1'>   $TEXT  </span>\
<span foreground='$COLOR1' background='#000000'></span>"

# ───────────── PAUSED ─────────────
elif [[ "$status" == "Paused" ]]; then
    echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span foreground='#ffffff' background='$COLOR2'>   Paused 󰏤 </span>\
<span foreground='$COLOR2' background='#000000'></span>"

# ───────────── STOPPED ─────────────
else
    echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span background='$COLOR2'>  󰇘  </span>\
<span foreground='$COLOR2' background='#000000'></span>"
fi
