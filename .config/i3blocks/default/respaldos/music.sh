#!/bin/bash

STATE="/tmp/player_show_artist"

# Click izquierdo → play / pause
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    playerctl play-pause 2>/dev/null
elif [[ "$BLOCK_BUTTON" == "3" ]]; then
    if [[ -f "$STATE" ]]; then
        rm "$STATE"
    else
        touch "$STATE"
    fi
fi

status=$(playerctl status 2>/dev/null)

# ───────────── COLORS ─────────────
COLOR1="#0C1240"
COLOR2="#263380"
COLOR3=""
MAX=45

# ───────────── PLAYING ─────────────
if [[ "$status" == "Playing" ]]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)

    # Recortar título
    if [[ ${#title} -gt $MAX ]]; then
        title="${title:0:$MAX}…"
    fi

    if [[ -f "$STATE" ]]; then
        echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span foreground='#ffffff' background='$COLOR2'>   Playing 󰐊 </span> \
<span background='$COLOR1'>   $artist - $title </span>\
<span foreground='$COLOR1' background='#000000'></span>"
    else
        echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span foreground='#ffffff' background='$COLOR2'>   Playing 󰐊 </span> \
<span background='$COLOR1'>   $title </span>\
<span foreground='$COLOR1' background='#000000'></span>"
   fi

# ───────────── PAUSED ─────────────
elif [[ "$status" == "Paused" ]]; then
    echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span foreground='#ffffff' background='$COLOR2'>   Paused 󰏤 </span>\
<span foreground='$COLOR2' background='#000000'></span>"

# ───────────── STOPPED / NADA ─────────────
else
    echo "<span foreground='$COLOR1' background='#ffffff'>  </span> \
<span background='$COLOR2'>  󰇘 </span>\
<span foreground='$COLOR2' background='#000000'></span>"
fi
