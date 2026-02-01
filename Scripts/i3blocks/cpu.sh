#!/bin/bash

STATE=/tmp/cpu_stat_prev

# Leer muestra actual
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
total=$((user+nice+system+idle+iowait+irq+softirq+steal))

# Si no existe archivo previo, guárdalo y sal
if [ ! -f "$STATE" ]; then
    echo "$user $nice $system $idle $iowait $irq $softirq $steal $total" > "$STATE"
    echo "0.0%"
    exit
fi

# Leer valores previos
read user_p nice_p system_p idle_p iowait_p irq_p softirq_p steal_p total_p < "$STATE"

# Guardar valores actuales para la próxima ejecución
echo "$user $nice $system $idle $iowait $irq $softirq $steal $total" > "$STATE"

# Calcular diferencias
total_diff=$((total - total_p))
idle_diff=$((idle - idle_p))

# Uso CPU con decimales
usage=$(awk "BEGIN {printf \"%.1f\", (100 * ($total_diff - $idle_diff) / $total_diff)}")

printf "<span foreground='#00665A' background='#ffffff'>  </span><span background='#00665A'>  %s </span><span foreground='#00665A' background='#000000'> </span>\n" "${usage}%"
