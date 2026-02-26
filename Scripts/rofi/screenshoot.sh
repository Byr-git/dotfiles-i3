#!/bin/bash

DIR="$HOME/Imágenes/Capturas"
DIR2="/tmp"

FILE="$DIR/$(date +%Y-%m-%d_%H%M%S).png"
FILE2="$DIR2/$(date +%Y-%m-%d_%H%M%S).png"
REAL="${FILE#$HOME/}"

DMENU=(dmenu -i -c -l 6 -bw 1 -h 30 -fn "Arimo Nerd Font-10" -sb "#263380" -nb "#0F1011" -nf '#ebdbb2' -p " Screenshoot: ")

# Menú de opciones
OPTION=$(printf "󰹑 Pantalla Completa\n󱅫 Notificación\n󱣴 Capturar Área\n󱂬 Capturar Ventana\n󱫢 Captura +3-Seg." | "${DMENU[@]}")
SUB_OPTION=$(printf "$OPTION")

case "$OPTION" in
    "󰹑 Pantalla Completa")
        sleep 0.2
        scrot --pointer "$FILE"
        ;;
    "󱅫 Notificación")
    	scrot --pointer "$FILE2"
    	sleep 3
    	notify-send -u low -i "$FILE2" "󰆓 Capturado:" "~/$REAL"
    	sleep 0.2
    	scrot --pointer "$FILE"
    	rm -f "$FILE2"
    	;;    
    "󱣴 Capturar Área")
        sleep 0.2
        scrot --select --line mode=edge "$FILE"
        ;;
    "󱂬 Capturar Ventana")
        sleep 0.2
        scrot --focused "$FILE"
        ;;
    "󱫢 Captura +3-Seg.")
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
