#!/bin/bash

PART="/"
STATE_FILE="/tmp/i3blocks_disk_mode"

# Leer estado (0 = completo, 1 = solo free)
mode=0
if [[ -f "$STATE_FILE" ]]; then
    read -r mode < "$STATE_FILE"
fi

# Si hay click izquierdo, alternar estado
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    mode=$((1 - mode))
    echo "$mode" > "$STATE_FILE"
fi

# Tomamos los valores con df (en KB)
read total used free <<< $(df -Pk "$PART" | awk 'NR==2 {print $2, $3, $4}')

# Convertir a GB (1 decimal)
free_gb=$(awk -v kb="$free" 'BEGIN {printf "%.1f", kb/1048576}')

# Porcentaje libre
percent=$(( free * 100 / total ))

printf "%s" "<span foreground='#0C1240' background='#ffffff'>  </span> "
printf "%s" "<span background='#263380'>  "

if [[ "$mode" == "1" ]]; then
    # Vista completa
    printf "%s" "${free_gb}G  ${percent}%"
else
    # Vista minimalista
    printf "%s" "${free_gb}G"
fi

printf "%s\n" " </span><span foreground='#263380' background='#000000'> </span>"
