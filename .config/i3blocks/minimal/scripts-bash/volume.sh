#!/bin/bash

COLOR1="#FFEECC"
COLOR2="#ffffff"

# Mostrar volumen actual
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
vol_num=${vol%\%}

# Detectar clics
case $BLOCK_BUTTON in
    1) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;	# clic izquierdo
    4) if [ "$vol_num" -lt 100 ]; then
           pactl set-sink-volume @DEFAULT_SINK@ +5%
       fi ;;						# scroll arriba
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;	# scroll abajo
    3) pavucontrol & ;;                                 # clic derecho
esac

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
vol_num=${vol%\%}

if [ "$mute" = "no" ]; then
    if [ "$vol_num" -eq 0 ]; then
        icon=~/.icons/Win11-dark/actions/16/player-volume-muted.svg
    else
        icon=~/.icons/Win11-dark/actions/16/irc-voice.svg
    fi

    dunstify -a "volume" -u low -r 9993 \
        -h int:value:"$vol_num" \
        -i "$icon" "Volumen:" "$vol"
else
    pkill dunst
fi

#if [ "$mute" = "no" ]; then
#    printf "<span foreground='#1871C9' background='#ffffff'>  </span><span background='#1871C9'>  %s </span><span #foreground='#1871C9' background='#000000'> </span>\n" ""
#else

if [ "$mute" = "no" ]; then
    printf "<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>\
<span fgcolor='%s' size='8000'>  </span>" "$COLOR1" "$COLOR2"
else
    printf "<span fgcolor='%s' fgalpha='60%%' size='10000'> </span>\
<span fgcolor='%s'>  </span>" "$COLOR1" "$COLOR2"
fi
