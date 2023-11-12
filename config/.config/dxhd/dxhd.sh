#!/bin/bash
## screenshot functions

scrot_template="$HOME/Pictures/Screenshot_%F_%H-%M-%S.png"
scrot_lineopts="mode=edge,width=4,color=red,opacity=70"

# super + d
rofi -theme launcher -show drun

# super + Tab
rofi -show window \
    -kb-cancel "Super+Escape,Escape" \
    -kb-accept-entry "!Super+Tab,!Super_L,!Super+Super_L,!Super+ISO_Left_Tab,Return" \
    -kb-row-down "Super+Tab,Super+Down,Down" \
    -kb-row-up "Super+ISO_Left_Tab,Super+Shift+Tab,Super+Up,Up"

# super + Return
## st
tym

# super + shift + Return
## st -c floating
tym --role=floating

# super + w
firefox

# super + e
nemo

# super + d
rofi -theme launcher -show drun

# super + ctrl + l
slock

# super + {bracketleft,bracketright,backslash}
statusctl vol {down,up,mute}

# XF86Audio{LowerVolume,RaiseVolume,Mute}
statusctl vol {down,up,mute}

# super + {minus,equal}
statusctl backlight {down,up}

# XF86MonBrightness{Down,Up}
statusctl backlight {down,up}

# super + shift + {minus,equal}
mpc -q seek {-,+}10

# super + shift + {bracketright,bracketleft}
mpc -q {next,prev}

# super + shift + backslash
statusctl mpd pause

# @Print
scrot "$scrot_template"

# ctrl + @Print
scrot - | xclip -selection clipboard -t image/png

# shift + @Print
scrot -s -l "$scrot_lineopts" "$scrot_template"

# ctrl + shift + @Print
scrot -s -l "$scrot_lineopts" - | xclip -selection clipboard -t image/png

# super + r
rofi -show run

# XF86Display
setmonitor

# super + p
setmonitor

# super + shift + p
openrefs

# super + shift + ctrl + p
openpdf
