#!/bin/bash

DMENU=(dmenu -i -c -l 10 -bw 1 -h 30 -fn "Arimo Nerd Font-10" -sb "#263380" -nb "#0F1011" -nf '#ebdbb2')

# --- MENÚ PRINCIPAL ---
MODE=$(printf " Configuración i3wm\n Configuración i3Blocks\n Configuración Dunst\n Configuración LXTerminal" | "${DMENU[@]}" -p " Archivos Config.: ")
[ -z "$MODE" ] && exit

case "$MODE" in
    " Configuración i3wm")
        leafpad ~/.config/i3/config
        ;;
    " Configuración i3Blocks")
        leafpad ~/.config/i3blocks/config
        ;;
    " Configuración Dunst")
        leafpad ~/.config/dunst/dunstrc
        ;;
    " Configuración LXTerminal")
        leafpad ~/.config/lxterminal/lxterminal.conf
        ;;
    *)
        exit 0
        ;;
esac