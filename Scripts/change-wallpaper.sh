#!/bin/bash

WALLPAPERS="$HOME/Wallpapers"
STATE="$HOME/.cache/current_wallpaper"

apply_wallpaper() {
    [ -f "$STATE" ] && xwallpaper --center "$(cat "$STATE")"
}

choose_wallpaper() {
    DMENU=(dmenu -i -c -l 6 -bw 1 -h 30 -fn "Arimo Nerd Font-10" -sb "#263380" -nb "#0F1011" -nf '#ebdbb2' -p "󰸉 Wallpapers: ")

    chosen=$(ls "$WALLPAPERS" | grep -Ei '\.(jpg|png|jpeg)$' | "${DMENU[@]}")
    [ -z "$chosen" ] && exit 0

    fullpath="$WALLPAPERS/$chosen"

    # Cambiar fondo
    xwallpaper --center "$fullpath"
    printf '%s\n' "$fullpath" > "$STATE"

    notify-send -u low -i "$fullpath" "Wallpaper" "Cambiado correctamente"
}

case "$1" in
    apply)
        apply_wallpaper
        ;;
    choose|"")
        choose_wallpaper
        ;;
esac