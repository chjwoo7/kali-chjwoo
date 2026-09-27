#!/bin/sh

state_dir=${XDG_RUNTIME_DIR:-/tmp}
state_file="$state_dir/i3blocks-cpu-${UID:-$(id -u)}"

read _ user nice system idle iowait irq softirq steal _ < /proc/stat
idle_total=$((idle + iowait))
total=$((user + nice + system + idle + iowait + irq + softirq + steal))

if [ -r "$state_file" ]; then
    read previous_total previous_idle < "$state_file"
    total_delta=$((total - previous_total))
    idle_delta=$((idle_total - previous_idle))
    if [ "$total_delta" -gt 0 ]; then
        usage=$((100 * (total_delta - idle_delta) / total_delta))
        printf '<span size="small">CPU %s%%</span>\n' "$usage"
    else
        printf '<span size="small">CPU --</span>\n'
    fi
else
    printf '<span size="small">CPU --</span>\n'
fi

printf '%s %s\n' "$total" "$idle_total" > "$state_file"
