#!/bin/bash

FOLDER="$HOME/Scripts"

# listar los archivos de la carpeta
if [ -z "$1" ]; then
    ls "$FOLDER"
else
    # Ejecutarlo
    coproc ( "$FOLDER/$1" > /dev/null 2>&1 )
    exit
fi