#!/bin/bash

notificacion() {
if [[ $ELECCION == " Apagar" ]]; then
    titulo="Apagando..."
elif [[ $ELECCION == " Reiniciar" ]]; then
    titulo="Reiniciando..."
else
    titulo="Cerrando Sesión..."
fi

for i in {0..100..10}; do
  notify-send \
    -h int:value:$i \
    -h string:x-dunst-stack-tag:carga_demo \
    -t 3000 \
    -i "~/Imágenes/icons/indicator-messages.svg" \
    "$titulo" \
    "Por favor espera"
  sleep 0.2727
done
}

menu_apagado() {
OPCIONES=" Apagar\n Reiniciar\n󰿅 Cerrar Sesión"

# Mostrar el menú con dmenu
ELECCION=$(echo -e "$OPCIONES" | dmenu -i -c -l 6 -bw 1 -h 30 -fn "Arimo Nerd Font-10" -sb "#263380" -nb "#0F1011" -nf "#ebdbb2" -p "󰹯 Menú de Apagado: ")

# Ejecutar según elección
case "$ELECCION" in
    " Apagar")
        notificacion
        sudo /sbin/shutdown -h now
        ;;
    " Reiniciar")
        notificacion
        sudo /sbin/shutdown -r now
        ;;
    "󰿅 Cerrar Sesión")
        notificacion
        i3-msg exit
        ;;
    *)
esac
}

case $BLOCK_BUTTON in
    1)  menu_apagado ;;	# clic izquierdo
esac

printf "<span foreground='#ffffff' background='#000000'>⏻  </span>\n"
