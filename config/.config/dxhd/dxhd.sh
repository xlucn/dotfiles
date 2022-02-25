#!/bin/bash

# super + d
rofi -theme launcher -show drun

# super + Tab
rofi -show window \
    -kb-cancel "Super+Escape,Escape" \
    -kb-accept-entry "!Super+Tab,!Super_L,!Super+Super_L,!Super+ISO_Left_Tab,Return" \
    -kb-row-down "Super+Tab,Super+Down,Down" \
    -kb-row-up "Super+ISO_Left_Tab,Super+Shift+Tab,Super+Up,Up"

# super + Return
st

# super + shift + Return
st -c floating

# super + w
firefox

# super + e
pcmanfm

# super + d
rofi -theme launcher -show drun

# super + ctrl + l
slock

# super + {bracketleft,bracketright,backslash}
amixer -q sset Master {4%-,4%+,toggle}
pkill -RTMIN+3 -f "[0-9 ]*python.*statusd"

# XF86Audio{LowerVolume,RaiseVolume,Mute}
amixer -q sset Master {4%-,4%+,toggle}
pkill -RTMIN+3 -f "[0-9 ]*python.*statusd"

# super + {minus,equal}
brightnessctl -c backlight -q s 4%{-,+}
pkill -RTMIN+4 -f "[0-9 ]*python.*statusd"

# XF86MonBrightness{Down,Up}
brightnessctl -c backlight -q s 4%{-,+}
pkill -RTMIN+4 -f "[0-9 ]*python.*statusd"

# super + shift + {minus,equal}
mpc -q seek {-,+}10

# super + shift + {bracketright,bracketleft,backslash}
mpc -q {next,prev,toggle}
pkill -RTMIN+5 -f "[0-9 ]*python.*statusd"

# @Print
scrot "$HOME/Pictures/Screenshot_%F_%H-%M-%S.png"

# ctrl + @Print
tmpfile=$(mktemp -u --tmpdir scrot.temp.XXXX.png)
scrot "$tmpfile"
xclip -selection clipboard -t image/png < "$tmpfile"
rm "$tmpfile"

# shift + @Print
scrot -s --line mode=edge,width=4,color=red,opacity=70 "$HOME/Pictures/Screenshot_%F_%H-%M-%S.png"

# ctrl + shift + @Print
scrot -s --line mode=edge,width=4,color=red,opacity=70 "$tmpfile"
xclip -selection clipboard -t image/png < "$tmpfile"
rm "$tmpfile"

# super + r
rofi -show run

# XF86Display
setmonitor

# super + p
setmonitor

## Translate selected text with translate-shell
## Idea from https://github.com/4lgn/word-lookup
# super + shift + t
st -c floating sh -c "trans \"$(xclip -o)\" | less -R"
