#!/bin/bash
### Script de gestión Hamachi en Debian (SysVinit)
### Guardar como: hamachi-manager.sh
### Dar permisos: chmod +x hamachi-manager.sh

SERVICE="logmein-hamachi"

start_service() {
    echo "[+] Iniciando servicio de Hamachi..."
    sudo /etc/init.d/$SERVICE start
}

stop_service() {
    echo "[+] Deteniendo servicio de Hamachi..."
    sudo /etc/init.d/$SERVICE stop
}

login() {
    echo "[+] Iniciando sesión en Hamachi..."
    sudo hamachi login
}

logout() {
    echo "[+] Cerrando sesión en Hamachi..."
    sudo hamachi logout
}

fix_routes() {
    echo "[+] Corrigiendo rutas..."
    sudo ip route del 0.0.0.0 dev ham0
    sudo ip route del default dev ham0
    echo "[+] Rutas ajustadas."
}

join_network() {
    read -p "ID de red Hamachi: " NETID
    read -s -p "Contraseña (si aplica, Enter si no): " NETPASS
    echo
    if [ -z "$NETPASS" ]; then
        sudo hamachi join "$NETID"
    else
        sudo hamachi join "$NETID" "$NETPASS"
    fi
}

leave_network() {
    read -p "ID de red Hamachi a salir: " NETID
    sudo hamachi leave "$NETID"
}

show_menu() {
    echo "===== Hamachi Manager ====="
    echo "1) Iniciar servicio"
    echo "2) Detener servicio"
    echo "3) Login"
    echo "4) Logout"
    echo "5) Arreglar rutas"
    echo "6) Unirse a red"
    echo "7) Salir de red"
    echo "0) Salir"
    echo "==========================="
}

while true; do
    show_menu
    read -p "Selecciona opción: " opt
    case $opt in
        1) start_service ;;
        2) stop_service ;;
        3) login ;;
        4) logout ;;
        5) fix_routes ;;
        6) join_network ;;
        7) leave_network ;;
        0) exit 0 ;;
        *) echo "Opción inválida" ;;
    esac
    echo
done
