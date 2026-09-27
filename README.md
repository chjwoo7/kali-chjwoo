# Kali i3 setup

Personal Kali desktop configuration based on the i3 setup from
[xct/kali-clean](https://github.com/xct/kali-clean), with the configs currently
used on my machine.

## Included

- i3 keybindings, gaps, startup commands, and i3blocks status bar
- Rofi application launcher
- Compton compositor settings
- Alacritty terminal settings
- Wallpaper and the VMware clipboard helper

## Install

Clone this repository as `~/kali-chjwoo`, then run:

```sh
./install.sh
```

The installer links the included files into your home directory. If a target
already exists, it moves it into
`~/.local/share/kali-chjwoo-backup/<timestamp>/` first. Log out and choose i3
from the login screen, or reload i3 with `Super+Shift+C` after installing.

The VMware clipboard helper only applies when Kali runs in a VMware guest.
