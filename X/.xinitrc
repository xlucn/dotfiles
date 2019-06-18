[[ -f $HOME/.xprofile ]] && . $HOME/.xprofile

# the last if block in /etc/X11/xinit/xinitrc
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec awesome
