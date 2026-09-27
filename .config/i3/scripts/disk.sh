#!/bin/sh

df -P "$HOME" | awk 'NR == 2 { printf "<span size=\"11pt\"><b>DISK</b> %s used</span>\n", $5 }'
