#!/bin/bash

awk '
/MemTotal/     { total = $2 }
/MemFree/      { free = $2 }
/Buffers/      { buffers = $2 }
/^Cached:/     { cached = $2 }

END {
    used = total - free - buffers - cached
    printf " %dMB / %dMB\n", used/1024, (total-used)/1024
}
' /proc/meminfo
