#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_dir="$HOME/.local/share/kali-chjwoo-backup/$(date +%Y%m%d-%H%M%S)"
dependency_mode=ask

usage() {
    cat <<'EOF'
Usage: ./install.sh [--install-deps | --no-deps]

Links this repository's dotfiles into the home directory, backing up existing
targets first. Missing runtime packages are offered for installation.

  --install-deps  Install missing packages with apt without prompting
  --no-deps       Only link the dotfiles; do not check/install packages
  -h, --help      Show this help
EOF
}

case "${1:-}" in
    --install-deps) dependency_mode=install ;;
    --no-deps) dependency_mode=skip ;;
    -h|--help) usage; exit 0 ;;
    "") ;;
    *) usage >&2; exit 2 ;;
esac

install_packages() {
    if ! command -v apt-get >/dev/null 2>&1; then
        printf 'This installer can install dependencies only on Kali/Debian systems with apt-get.\n' >&2
        return 1
    fi

    if [ "$(id -u)" -eq 0 ]; then
        apt-get update
        apt-get install -y --no-install-recommends $missing_packages
    elif command -v sudo >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y --no-install-recommends $missing_packages
    else
        printf 'Install these packages manually: %s\n' "$missing_packages" >&2
        return 1
    fi
}

check_dependencies() {
    [ "$dependency_mode" = skip ] && return

    missing_packages=
    for pair in \
        i3:i3-wm \
        i3blocks:i3blocks \
        kitty:kitty \
        picom:picom \
        rofi:rofi \
        alacritty:alacritty \
        feh:feh \
        flameshot:flameshot \
        i3lock:i3lock \
        thunar:thunar \
        wpctl:pipewire-bin \
        firefox:firefox-esr \
        vmtoolsd:open-vm-tools-desktop \
        tmux:tmux \
        zsh:zsh \
        fzf:fzf \
        xclip:xclip
    do
        command_name=${pair%%:*}
        package_name=${pair#*:}
        if ! command -v "$command_name" >/dev/null 2>&1; then
            missing_packages="$missing_packages $package_name"
        fi
    done

    if command -v fc-list >/dev/null 2>&1; then
        if ! fc-list : family | grep -Eqi 'JetBrains ?Mono'; then
            missing_packages="$missing_packages fonts-jetbrains-mono"
        fi
    else
        missing_packages="$missing_packages fontconfig fonts-jetbrains-mono"
    fi

    if [ -z "$missing_packages" ]; then
        return
    fi

    printf 'Missing runtime packages:%s\n' "$missing_packages"
    if [ "$dependency_mode" = install ]; then
        install_packages
        return
    fi

    printf 'Install them now? [y/N] '
    if [ -t 0 ]; then
        read answer || answer=
    else
        answer=
    fi
    case "$answer" in
        y|Y|yes|YES) install_packages ;;
        *) printf 'Skipping packages. Run ./install.sh --install-deps to install them later.\n' ;;
    esac
}

check_dependencies

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
link_config .config/picom
link_config .config/alacritty
link_config .config/kitty
link_config .tmux.conf
link_config .zshrc
link_config .wallpaper
link_config .fehbg
