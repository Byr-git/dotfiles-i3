#!/bin/bash

# Toggle con click izquierdo
if [ "$BLOCK_BUTTON" -eq 1 ]; then
    if pgrep -x gsimplecal >/dev/null; then
        pkill -x gsimplecal
    else
        gsimplecal &
    fi
fi

# Alinear al próximo :00 antes de entrar al bucle
sleep $((60 - $(date +%S)))

while true; do
    printf "<span foreground='#303F9F' background='#ffffff'> 󰥔 </span><span background='#303F9F'>  %s </span><span foreground='#303F9F' background='#000000'> </span>\n" "$(date '+%H:%M  %d-%m-%Y')"

    # Dormir hasta el siguiente minuto exacto
    sleep $((60 - $(date +%S)))
done
