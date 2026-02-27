#!/bin/bash

# --- CONFIGURACIÓN ---
AUDIO_DIR="$HOME/Música"
VIDEO_DIR="$HOME/Vídeos"
mkdir -p "$AUDIO_DIR" "$VIDEO_DIR"
GENERAL_CONFIG='mode-switcher { enabled: false; }'
LISTVIEW="listview { lines: 2; columns: 2; } $GENERAL_CONFIG"

# --- MENÚ PRINCIPAL ---
MODE=$(printf "Audio\nVideo" | rofi -dmenu -i -p " " -theme-str "entry { placeholder: \"¿Qué quieres descargar?\"; } $GENERAL_CONFIG")
[ -z "$MODE" ] && exit

# --- MENÚ DE CALIDAD ---
if [ "$MODE" = "Audio" ]; then
    QUALITY=$(printf "320 kbps\n192 kbps\n128 kbps" | rofi -dmenu -i -p "󰌳  Audio:" -theme-str "entry { placeholder: \"Seleccione una opción...\"; } $LISTVIEW")
    [ -z "$QUALITY" ] && exit
    case "$QUALITY" in
        *320*) Q=0 ;; # ffmpeg: 0 = mejor calidad
        *192*) Q=5 ;;
        *128*) Q=9 ;;
    esac
else
    QUALITY=$(printf "1080p\n720p\n480p\n360p" | rofi -dmenu -i -p "  Video:" -theme-str "entry { placeholder: \"Seleccione una opción...\"; } $LISTVIEW")
    [ -z "$QUALITY" ] && exit
    case "$QUALITY" in
        1080p) F="bestvideo[height<=1080]+bestaudio" ;;
        720p)  F="bestvideo[height<=720]+bestaudio" ;;
        480p)  F="bestvideo[height<=480]+bestaudio" ;;
        360p)  F="bestvideo[height<=360]+bestaudio" ;;
    esac
fi

# --- PEDIR URL ---
# Se usa 'echo' para evitar problemas de entrada bloqueada
URL=$(echo | rofi -dmenu -p "  URL: " -theme-str "entry { placeholder: \"Pegue aquí la URL...\"; } \
	listview { enabled: false; } \
	input { enabled: false; } $GENERAL_CONFIG")
[ -z "$URL" ] && exit

# --- DESCARGA ---
if [ "$MODE" = "Audio" ]; then
    notify-send "  Descargando audio..." "Iniciando descarga del audio"
    if yt-dlp -f bestaudio \
        --extract-audio --audio-format mp3 --audio-quality "$Q" \
        -o "$AUDIO_DIR/%(title)s.%(ext)s" \
        "$URL"; then
		notify-send "  Descarga completada" "Audio guardado en $AUDIO_DIR"; else	
		notify-send "  Error en la descarga" "No se pudo completar la descarga del audio"
	fi
else
    notify-send "  Descargando video..." "Descargando video con calidad: $QUALITY"
    if yt-dlp -f "$F" --merge-output-format mp4 \
        -o "$VIDEO_DIR/%(title)s.%(ext)s" \
        "$URL"; then
		notify-send "  Descarga completada" "Video guardado en $VIDEO_DIR"; else
		notify-send "  Error en la descarga" "No se pudo completar la descarga del video"
	fi
fi
