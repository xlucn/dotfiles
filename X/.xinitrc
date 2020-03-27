#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

fcitx -d
pgrep -x picom || picom &
pgrep -x udiskie || udiskie -s &
pgrep -x nm-applet || nm-applet &
pgrep -x redshift-gtk || redshift-gtk &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
[ -x /usr/local/bin/udev-local ] && udev-local &

exec awesome
