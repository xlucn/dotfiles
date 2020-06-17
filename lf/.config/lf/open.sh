#!/bin/sh
case "$(file -Lb --mime-type -- "$1")" in
    text/html)
        if [ -n "$DISPLAY" ]; then
            firefox -- "$@"
        else
            lynx "$@" || elinks "$@" || w3m "$@" || links "$@"
        fi ;;
    text/*|*/xml|*/csv|*/json)
        ${EDITOR:-vim} "$@" ;;
    video/*)
        if [ -n "$DISPLAY" ]; then
            mpv -- "$@" || mplayer -- "$@"
        else
            cmplayer "$@" ||
            mplayer -vo fbdev2 -vc ffh264, -- "$@" ||
            mpv --vo=gpu --gpu-context=drm --msg-level=all=no -- "$@"
        fi ;;
    audio/*)
        mpv -- "$@" || mplayer -- "$@" ;;
    application/pdf)
        if [ -n "$DISPLAY" ]; then
            zathura "$@"
        else
            jfbview "$@"
        fi ;;
    image/*)
        if [ -n "$DISPLAY" ]; then
            sxiv "$@" || vimiv "$@"
        else
            jfbview "$@" || fbv "$@"
        fi ;;
    *)
        if [ -n "$DISPLAY" ]; then
            for f in "$@"; do
                xdg-open "$f"
            done &
        fi ;;
esac
