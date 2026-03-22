#!/bin/bash

# Esperar al inicio exacto del próximo minuto
while [ "$(date +%S)" != "00" ]; do
    sleep 0.2
done

#printf "<span foreground='#0C1240' background='#ffffff'> 󰥔 </span> \
#<span background='#263380'>   %s   </span> \
#<span background='#263380'>   %s   </span>\
#<span foreground='#263380' background='#000000'> </span>\n" \
#"$(date '+%H:%M')" "$(date '+%d-%m-%Y')"

printf "<span foreground='#0C1240' background='#ffffff'> 󰥔 </span> \
<span background='#263380'>  %s  </span>\
<span foreground='#263380' background='#000000'> </span>\n" \
"$(date '+%a %H:%M' | sed 's/^./\U&/')"