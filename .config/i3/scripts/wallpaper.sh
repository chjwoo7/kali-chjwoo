#!/bin/sh

wallpaper_dir="$HOME/.wallpaper"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/kali-chjwoo"
state_file="$state_dir/wallpaper"

wallpapers=$(find "$wallpaper_dir" -type f \( \
    -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o \
    -iname '*.webp' -o -iname '*.bmp' -o -iname '*.gif' \
\) -print 2>/dev/null | sort)

if [ -z "$wallpapers" ]; then
    rofi -e "No wallpapers found in $wallpaper_dir"
    exit 0
fi

selected=$(printf '%s\n' "$wallpapers" | rofi -dmenu -i -p 'Wallpaper')
[ -n "$selected" ] || exit 0
[ -f "$selected" ] || exit 1

if feh --no-fehbg --bg-fill "$selected"; then
    mkdir -p "$state_dir"
    printf '%s\n' "$selected" > "$state_file"
fi
