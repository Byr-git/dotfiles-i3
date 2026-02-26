#!/bin/bash

DMENU=(rofi -dmenu -i -p "" -theme-str 'entry { placeholder: "Selecciona una opción..."; }')

# --- MENÚ PRINCIPAL ---
MODE=$(printf "  Configuración i3wm\n  Configuración i3Blocks\n  Configuración Dunst\n  Configuración LXTerminal\n  Configuración Rofi" | "${DMENU[@]}")
[ -z "$MODE" ] && exit

case "$MODE" in
    "  Configuración i3wm")
        geany ~/.config/i3/config
        ;;
    "  Configuración i3Blocks")
        geany ~/.config/i3blocks/config
        ;;
    "  Configuración Dunst")
        geany ~/.config/dunst/dunstrc
        ;;
    "  Configuración LXTerminal")
        geany ~/.config/lxterminal/lxterminal.conf
        ;;
    "  Configuración Rofi")
        geany ~/.config/rofi/config.rasi
        ;;       
    *)
        exit 0
        ;;
esac
