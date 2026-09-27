#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_dir="$HOME/.local/share/kali-chjwoo-backup/$(date +%Y%m%d-%H%M%S)"

link_config() {
    relative_path=$1
    source_path="$repo_dir/$relative_path"
    target_path="$HOME/$relative_path"

    mkdir -p "$(dirname -- "$target_path")"

    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
        return
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        mkdir -p "$backup_dir/$(dirname -- "$relative_path")"
        mv -- "$target_path" "$backup_dir/$relative_path"
        printf 'Backed up %s to %s\n' "$target_path" "$backup_dir/$relative_path"
    fi

    ln -s "$source_path" "$target_path"
    printf 'Linked %s\n' "$target_path"
}

link_config .config/i3
link_config .config/rofi
link_config .config/compton
link_config .config/alacritty
link_config .wallpaper
link_config .fehbg

