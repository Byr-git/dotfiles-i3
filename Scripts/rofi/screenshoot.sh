#!/bin/bash

DIR="$HOME/Imágenes/Capturas"
DIR2="/tmp"

FILE="$DIR/$(date +%Y-%m-%d_%H%M%S).png"
FILE2="$DIR2/$(date +%Y-%m-%d_%H%M%S).png"
REAL="${FILE#$HOME/}"

DMENU=(rofi -dmenu -i -theme horizontal.rasi -p "  Captura" -theme-str "entry { placeholder: \"Elige una opción...\"; }")

# Menú de opciones
OPTION=$(printf "󰹑\n󱅫\n󱣴\n󱂬\n󱫢" | "${DMENU[@]}")
SUB_OPTION=$(printf "$OPTION")

case "$OPTION" in
    "󰹑")
        sleep 0.2
        scrot --pointer "$FILE"
        ;;
    "󱅫")
    	scrot --pointer "$FILE2"
    	sleep 3
    	notify-send -u low -i "$FILE2" "󰆓 Capturado:" "~/$REAL"
    	sleep 0.2
    	scrot --pointer "$FILE"
    	rm -f "$FILE2"
    	;;    
    "󱣴")
        sleep 0.2
        scrot --select --line mode=edge "$FILE"
        ;;
    "󱂬")
        sleep 0.2
        scrot --focused "$FILE"
        ;;
    "󱫢")
        scrot --pointer -d 3 "$FILE"
        ;;
    *)
        exit 0
        ;;
esac

[ -f "$FILE" ] || exit 1

# Notificación con Dunst
xclip -selection clipboard -t image/png "$FILE"
notify-send -u low -i "$FILE" "󰆓 Capturado:" "~/$REAL"
