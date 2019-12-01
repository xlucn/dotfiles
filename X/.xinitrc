#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

# nocsd hack
# export GTK_CSD=0
# export LD_PRELOAD=/usr/lib/libgtk3-nocsd.so.0

# pgrep -x picom || picom &
# exec awesome
# exec startxfce4
