for i in {0..100..10}; do
  notify-send \
    -h int:value:$i \
    -h string:x-dunst-stack-tag:carga_demo \
    -t 3000 \
    -i "/home/suta/.icons/Win11-dark/status/16/indicator-messages.svg" \
    "Apagando..." \
    "Por favor espera"
  sleep 0.2727
done
