#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

WALLPAPER=$HOME/Pictures/wallpaper.jpg

prewm() {
    pgrep -x fcitx || fcitx -d > /dev/null 2>&1
    pgrep -x sxhkd || sxhkd > /dev/null 2>&1 &
    pgrep -x xcompmgr || xcompmgr &
    pgrep -x udiskie || udiskie > /dev/null 2>&1 &
    pgrep -x redshift || redshift > /dev/null 2>&1 &
    pgrep -x polkit-gnome-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 > /dev/null 2>&1 &
    pgrep -x udev-local || udev-local &
}

startdwm() {
    pgrep -x xwallpaper || xwallpaper --zoom "$WALLPAPER" --daemon
    pgrep -x dwm-status || dwm-status --daemon &
    exec dwm
}

startgnome() {
    export GTK_CSD=1
    export XDG_SESSION_TYPE=x11
    export GDK_BACKEND=x11
    exec gnome-session
}

if [ "${1%2x}" != "$1" ]; then
    export XCURSOR_SIZE=32
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    echo "Xft.dpi: 144" > /tmp/Xresources.Xft.dpi
    xrdb -merge /tmp/Xresources.Xft.dpi
fi

case ${1:-dwm} in
    awesome*) prewm; exec awesome;;
    xfce*) exec startxfce4;;
    gnome*) startgnome;;
    simple) st & startdwm;;
    dwm*) prewm; startdwm;;
    *) exec "$1";;
esac
