#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

fcitx -d
pgrep -x picom || picom &
pgrep -x udiskie || udiskie -s &
pgrep -x nm-applet || nm-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
exec awesome
