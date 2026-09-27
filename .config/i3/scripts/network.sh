#!/bin/sh

iface=${BLOCK_INSTANCE:-tun0}
case "$iface" in
    *[!a-zA-Z0-9_.:-]*|'') printf '<span size="11pt"><b>NET</b>: interface invalid</span>\n'; exit 0 ;;
esac

if [ ! -d "/sys/class/net/$iface" ]; then
    printf '<span size="11pt"><b>NET</b> %s down</span>\n' "$iface"
    exit 0
fi

ip_address=$(ip -4 -o addr show dev "$iface" scope global 2>/dev/null | awk 'NR == 1 { split($4, address, "/"); print address[1] }')
if [ -n "$ip_address" ]; then
    printf '<span size="11pt"><b>NET</b> %s</span>\n' "$ip_address"
else
    printf '<span size="11pt"><b>NET</b> %s no IPv4</span>\n' "$iface"
fi
