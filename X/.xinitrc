[[ -f $HOME/.Xmodmap ]] && xmodmap $HOME/.Xmodmap
[[ -f $HOME/.Xresources ]] && xrdb -load $HOME/.Xresources
[[ -f $HOME/.xprofile ]] && . $HOME/.xprofile
awesome
