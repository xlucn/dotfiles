#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

fcitx -d > /dev/null 2>&1 &
xcompmgr &
pgrep -x udiskie || udiskie &
pgrep -x redshift || redshift &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

udev-local &

hsetroot -cover .local/share/backgrounds/wallpaper.jpg &
while true; do dwm-status; sleep 1; done &
while true; do dwm; done
