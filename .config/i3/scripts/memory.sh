#!/bin/sh

awk '
    /^MemTotal:/ { total = $2 }
    /^MemAvailable:/ { available = $2 }
    END {
        used = total - available
        printf "<span size=\"small\">RAM %.1f/%.1fG (%d%%)</span>\n", used / 1048576, total / 1048576, used * 100 / total
    }
' /proc/meminfo
