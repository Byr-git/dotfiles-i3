#!/bin/bash

COLOR1="#FFEECC"
COLOR2="#ffffff"

# Esperar al inicio exacto del próximo minuto
while [ "$(date +%S)" != "00" ]; do
    sleep 0.2
done

printf "<span fgcolor='%s' fgalpha='50%%' size='10000'> </span>\
<span fgcolor='%s'>󰥔 </span>\
<span fgcolor='%s' weight='bold'>%s</span>\
<span fgcolor='%s' fgalpha='50%%' size='10000'> </span>" \
"$COLOR1" "$COLOR2" "$COLOR1" "$(date '+%a %H:%M' | sed 's/^./\U&/')" "$COLOR1"
