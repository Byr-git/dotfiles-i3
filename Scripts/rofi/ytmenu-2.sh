#!/bin/bash

# --- CONFIGURACIÓN ---
AUDIO_DIR="$HOME/Música"
VIDEO_DIR="$HOME/Vídeos"

mkdir -p "$AUDIO_DIR" "$VIDEO_DIR"

# --- MENÚ PRINCIPAL ---
MODE=$(printf "  Audio\n  Video" | rofi -dmenu -i -p "¿Qué quieres descargar? " -theme-str 'prompt { enabled: true; } entry { placeholder: ""; }')

[ -z "$MODE" ] && exit

# --- MENÚ DE CALIDAD ---
if [ "$MODE" = "  Audio" ]; then
    QUALITY=$(printf "320 kbps (máxima)\n192 kbps\n128 kbps" | rofi -dmenu -i -p "Selecciona la calidad de audio: " -theme-str 'prompt { enabled: true; } entry { placeholder: ""; }')
    [ -z "$QUALITY" ] && exit
    case "$QUALITY" in
        *320*) Q=0 ;;   # ffmpeg: 0 = mejor calidad
        *192*) Q=5 ;;
        *128*) Q=9 ;;
    esac
else
    QUALITY=$(printf "1080p\n720p\n480p\n360p" | rofi -dmenu -i -p "Selecciona la calidad de video: " -theme-str 'prompt { enabled: true; } entry { placeholder: ""; }')
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
URL=$(echo | rofi -dmenu -p "  URL: " -theme-str 'prompt { enabled: true; } entry { placeholder: ""; }')
[ -z "$URL" ] && exit

# --- DESCARGA ---
if [ "$MODE" = "  Audio" ]; then
    notify-send "  Descargando audio..." "Iniciando descarga de YouTube"
    yt-dlp -f bestaudio \
        --extract-audio --audio-format mp3 --audio-quality "$Q" \
        -o "$AUDIO_DIR/%(title)s.%(ext)s" \
        "$URL" && \
    notify-send "  Descarga completada" "Audio guardado en $AUDIO_DIR"
else
    notify-send "  Descargando video..." "Calidad: $QUALITY"
    yt-dlp -f "$F" --merge-output-format mp4 \
        -o "$VIDEO_DIR/%(title)s.%(ext)s" \
        "$URL" && \
    notify-send "  Descarga completada" "Video guardado en $VIDEO_DIR"
fi
