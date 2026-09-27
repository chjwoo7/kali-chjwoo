#!/bin/sh

df -P "$HOME" | awk 'NR == 2 { printf "<span size=\"small\">DISK %s used</span>\n", $5 }'
