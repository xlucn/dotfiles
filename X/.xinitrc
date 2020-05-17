#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

fcitx -d > /dev/null 2>&1
pgrep -x picom || picom --config /dev/null --backend glx --vsync &
pgrep -x udiskie || udiskie &
pgrep -x redshift || redshift &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
[ -x /usr/local/bin/udev-local ] && udev-local &

hsetroot -cover .local/share/backgrounds/wallpaper.jpg &
while true; do dwm-status; sleep 1; done &
while true; do dwm; done
