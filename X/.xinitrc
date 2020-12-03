#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

WALLPAPER=$HOME/.local/share/backgrounds/wallpaper.jpg

prewm() {
    fcitx -d > /dev/null 2>&1 &
    picom -b --experimental-backends
    pgrep -x udiskie || udiskie > /dev/null 2>&1 &
    pgrep -x redshift || redshift > /dev/null 2>&1 &
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 > /dev/null 2>&1 &
}

udev-local &

startdwm() {
    xwallpaper --zoom "$WALLPAPER" --daemon
    while true; do dwm-status; sleep 1; done &
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
    echo "Xft.dpi: 144" > /tmp/Xresources.hidpi
    xrdb -merge /tmp/Xresources.hidpi
    rm /tmp/Xresources.hidpi
fi

case ${1:-dwm} in
    awesome*) prewm; exec awesome;;
    xfce*) exec startxfce4;;
    gnome*) startgnome;;
    dwm*|*) prewm; startdwm;;
esac
