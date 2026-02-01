#!/bin/bash

WALLPAPERS="$HOME/Wallpapers"
I3CONFIG="$HOME/.config/i3/config"
DMENU=(dmenu -i -c -l 6 -bw 1 -h 30 -fn "Arimo Nerd Font-10" -sb "#263380" -nb "#0F1011" -nf '#ebdbb2' -p "󰸉 Wallpapers: ")

chosen=$(ls "$WALLPAPERS" | grep -Ei '\.(jpg|png|jpeg)$' | "${DMENU[@]}")

[ -z "$chosen" ] && exit 0

fullpath="$WALLPAPERS/$chosen"

# Cambiar fondo
notify-send -i "$fullpath" "Wallpaper" "Cambiado correctamente"
xwallpaper --center "$fullpath"

# Escapar ruta
escaped=$(printf '%q\n' "$fullpath")

# Actualizar config de i3
sed -i \
  "s|^exec --no-startup-id xwallpaper.*|exec --no-startup-id xwallpaper --center $fullpath|" \
  "$I3CONFIG"

# Salir explícitamente
exit 0