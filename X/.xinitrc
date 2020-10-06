#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile" &

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
    hsetroot -cover "$WALLPAPER" > /dev/null 2>&1 &
    while true; do dwm-status; sleep 1; done &
    exec dwm
}

startgnome() {
    export XDG_CURRENT_DESKTOP=GNOME-Classic:GNOME
    export GNOME_SHELL_SESSION_MODE=classic
    exec gnome-session --session=gnome-classic
}

case ${1:-dwm} in
    awesome*) prewm; exec awesome;;
    xfce*) exec startxfce4;;
    gnome*) startgnome;;
    dwm|*) prewm; startdwm;;
esac
