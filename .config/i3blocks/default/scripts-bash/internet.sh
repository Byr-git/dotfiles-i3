#!/bin/bash

# Script ultra rápido para i3blocks: conexión a internet (sin ping)
# Detecta si la interfaz está "up" y tiene ruta por defecto

IFACE="eth0"

# 1. Verificar si la interfaz está activa
if [[ "$(cat /sys/class/net/$IFACE/operstate 2>/dev/null)" != "up" ]]; then
    echo "<span foreground='#1871C9' background='#ffffff'>  </span><span background='#1871C9'>   Down </span><span foreground='#1871C9' background='#000000'> </span>"
    exit 0
fi

# 2. Verificar si hay una ruta por defecto en /proc/net/route
if awk -v iface="$IFACE" '$1 == iface && $2 == "00000000" && $3 != "00000000" {found=1} END{exit !found}' /proc/net/route; then
    echo "<span foreground='#1871C9' background='#ffffff'>  </span><span background='#1871C9'>  󰢾 </span><span foreground='#1871C9' background='#000000'> </span>"
else
    echo "<span foreground='#1871C9' background='#ffffff'>  </span><span background='#1871C9'>   Down </span><span foreground='#1871C9' background='#000000'> </span>"
fi
