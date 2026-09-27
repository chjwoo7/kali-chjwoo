#!/bin/sh

# VMware updates the preferred RandR mode on some guests without activating it.
# Apply that mode when VMware changes the guest window size.
lock_file="${XDG_RUNTIME_DIR:-/tmp}/i3-vmware-resize-watch-${UID:-$(id -u)}.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

while :; do
    output=$(xrandr --query 2>/dev/null) || {
        sleep 2
        continue
    }

    preferred=$(printf '%s\n' "$output" | awk '
        /^Virtual-1 connected/ { connected = 1; next }
        connected && /^[[:space:]]+[0-9]+x[0-9]+/ && /\+/ { print $1; exit }
        connected && /^[^[:space:]]/ { exit }
    ')
    current=$(printf '%s\n' "$output" | sed -n '1s/.*current \([0-9][0-9]* x [0-9][0-9]*\),.*/\1/p' | tr -d ' ')

    if [ -n "$preferred" ] && [ "$current" != "$preferred" ]; then
        xrandr --output Virtual-1 --mode "$preferred" >/dev/null 2>&1
    fi

    sleep 2
done
