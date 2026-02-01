#!/bin/bash

# --- CONFIGURACIÓN ---
AUDIO_DIR="$HOME/Música"
VIDEO_DIR="$HOME/Vídeos"

mkdir -p "$AUDIO_DIR" "$VIDEO_DIR"

DMENU=(dmenu -i -c -l 10 -bw 1 -h 30 -fn "Arimo Nerd Font-10" -sb "#263380" -nb "#0F1011" -nf '#ebdbb2')

# --- MENÚ PRINCIPAL ---
MODE=$(printf " Audio\n Video" | "${DMENU[@]}" -p " Descargar: ")
[ -z "$MODE" ] && exit

# --- MENÚ DE CALIDAD ---
if [ "$MODE" = " Audio" ]; then
    QUALITY=$(printf "320 kbps (máxima)\n192 kbps\n128 kbps" | "${DMENU[@]}" -p " Calidad de audio: ")
    [ -z "$QUALITY" ] && exit

    case "$QUALITY" in
        *320*) Q=0 ;;
        *192*) Q=5 ;;
        *128*) Q=9 ;;
    esac
else
    QUALITY=$(printf "1080p\n720p\n480p\n360p" | "${DMENU[@]}" -p " Calidad de video:  ")
    [ -z "$QUALITY" ] && exit

    case "$QUALITY" in
        1080p) F="bestvideo[height<=1080]+bestaudio" ;;
        720p)  F="bestvideo[height<=720]+bestaudio" ;;
        480p)  F="bestvideo[height<=480]+bestaudio" ;;
        360p)  F="bestvideo[height<=360]+bestaudio" ;;
    esac
fi

# --- PEDIR URL ---
URL=$(printf "" | "${DMENU[@]}" -p "URL:")
[ -z "$URL" ] && exit

# --- DESCARGA ---
if [ "$MODE" = " Audio" ]; then
    notify-send -i "~/Imágenes/icons/Download.svg" "  Descargando audio..." "Iniciando descarga"
    yt-dlp -f bestaudio --no-playlist \
        --extract-audio --audio-format mp3 --audio-quality "$Q" \
        -o "$AUDIO_DIR/%(title)s.%(ext)s" \
        "$URL" && \
    notify-send -i "~/Imágenes/icons/music.svg" "  Descarga completada" "Audio guardado en $AUDIO_DIR" || \
    notify-send -i "~/Imágenes/icons/off-symbolic.svg" "Error:" "Falló la descarga..."
else
    notify-send -i "~/Imágenes/icons/Download.svg" "  Descargando video..." "Calidad: $QUALITY"
    yt-dlp -f "$F" --merge-output-format mp4 \
        -o "$VIDEO_DIR/%(title)s.%(ext)s" \
        "$URL" && \
    notify-send -i "~/Imágenes/icons/music.svg" "  Descarga completada" "Video guardado en $VIDEO_DIR" || \
    notify-send -i "~/Imágenes/icons/off-symbolic.svg" "Error:" "Falló la descarga..."
fi
