#!/bin/sh

df -P "$HOME" | awk 'NR == 2 { printf "DISK %s used\n", $5 }'
