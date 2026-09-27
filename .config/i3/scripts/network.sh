#!/bin/sh

iface=${BLOCK_INSTANCE:-tun0}
case "$iface" in
    *[!a-zA-Z0-9_.:-]*|'') printf '<span size="small">NET: interface invalid</span>\n'; exit 0 ;;
esac

stats="/sys/class/net/$iface/statistics"
if [ ! -r "$stats/rx_bytes" ] || [ ! -r "$stats/tx_bytes" ]; then
    printf '<span size="small">NET %s down</span>\n' "$iface"
    exit 0
fi

rx=$(cat "$stats/rx_bytes")
tx=$(cat "$stats/tx_bytes")
now=$(date +%s)
state_dir=${XDG_RUNTIME_DIR:-/tmp}
state_file="$state_dir/i3blocks-net-${UID:-$(id -u)}-$iface"

if [ -r "$state_file" ]; then
    read previous_rx previous_tx previous_time < "$state_file"
    elapsed=$((now - previous_time))
    if [ "$elapsed" -gt 0 ]; then
        rx_rate=$(((rx - previous_rx) / elapsed / 1024))
        tx_rate=$(((tx - previous_tx) / elapsed / 1024))
    else
        rx_rate=0
        tx_rate=0
    fi
else
    rx_rate=0
    tx_rate=0
fi

printf '<span size="small">NET ↓%sK/s ↑%sK/s</span>\n' "$rx_rate" "$tx_rate"
printf '%s %s %s\n' "$rx" "$tx" "$now" > "$state_file"
