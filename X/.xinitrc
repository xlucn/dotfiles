#!/bin/sh
# shellcheck disable=SC1090

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

systemctl --user import-environment DISPLAY
WALLPAPER=$HOME/Pictures/wallpaper.jpg

startfcitx() {
    # chinese input method
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    pgrep -x fcitx || fcitx -d > /dev/null 2>&1
}

startibus() {
    # chinese input method
    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    pgrep -x ibus-daemon || ibus-daemon -x -d > /dev/null 2>&1
}

prewm() {
    startibus

    pgrep -x sxhkd || sxhkd > /dev/null 2>&1 &
    pgrep -x xcompmgr || xcompmgr &
    # pgrep -x udiskie || udiskie > /dev/null 2>&1 &
    pgrep -x redshift || redshift > /dev/null 2>&1 &
    pgrep -x polkit-gnome-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 > /dev/null 2>&1 &

    # configure trackpad
    for id in $(xinput list --id-only); do
        if xinput --list-props "$id" | grep -q "Tapping Enabled"; then
            xinput set-prop "$id" "libinput Tapping Enabled" 1
            xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1
            xinput set-prop "$id" "libinput Accel Speed" 0.5
        fi
    done
    libinput-gestures-setup restart > /dev/null 2>&1 &
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
