#!/bin/sh
# If not running interactively, don't do anything
[ "$-" = "${-#*i}" ] && return

if [ "$PS1" ] && [ -n "$BASH" ] && \
    [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck disable=1091
    . /usr/share/bash-completion/bash_completion
fi

# shellcheck source=/dev/null
. "$HOME"/.profile
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    # shellcheck source=/dev/null
    . /usr/bin/virtualenvwrapper.sh
fi

# Alias
command -v doas > /dev/null && alias sudo="doas"
# auto color
alias ls="ls --color=auto --classify"
alias grep="grep --color=auto"
# ask when replacing files
alias mv="mv -iv"
alias cp="cp -iv"
# do not show *tmpfs
alias df="df -h -x tmpfs -x devtmpfs -x efivarfs --output=source,fstype,size,used,avail,pcent,target"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-drmprime-video-plane=0"
# ranger under tty
alias cranger="ranger --cmd='set preview_images_method w3m'"
# vcsi alias with template
alias vcsi="vcsi -t --template \$HOME/.config/vcsi/template.txt"
# info with infokey file
alias info="info --init-file=\$XDG_CONFIG_HOME/infokey"
# x11vnc rc file
alias x11vnc="x11vnc -rc \$XDG_CONFIG_HOME/x11vncrc"
# quiet newsboat
alias newsboat="newsboat -q"
alias proxychains="proxychains -q"
# vim note
alias notes="lf \$HOME/Code/notes"
# ps grep
alias psg="pgrep -ifa"
# du tree
alias sdu="tree --du --sort=size -CFhrax"
# ffmpeg, quiet!
alias ffmpeg="ffmpeg -protocol_whitelist crypto,tls,file,tcp,https,http -hide_banner"
alias ffplay="ffplay -protocol_whitelist crypto,tls,file,tcp,https,http -hide_banner"
alias ffprobe="ffprobe -hide_banner"
# ncdu within one file system
alias ncdu="ncdu -x"
# arch linux update
alias au="sudo pacman -Syu && proxychains paru -Sua"
# fricas
alias fricas="fricas -nox -noht -rl"
alias neo-matrix="neo-matrix -a -D background -F"
# adb
alias adb='HOME="$XDG_DATA_HOME"/android adb'
# system backup
alias rsync-backup-to='sudo rsync -aAXz --delete --delete-excluded --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/var/tmp/*","/mnt/*","/media/*","/lost+found","/swap","/home/*/Music","/home/*/Videos","/home/*/Games","/home/*/.cache/paru"} /'

# pip update
pip_update() {
    pip list --outdated | tail -n+3 | cut -d " " -f 1 | xargs -r pip install --upgrade
}
# start xorg
x() {
    tty=$(tty)
    [ "${tty#/dev/tty}" = "$tty" ] && echo Not tty, exiting && return
    tty=${tty#/dev/tty}
    xauth add :"$tty" . "$(od -An -N16 -tx /dev/urandom | tr -d ' ')"
    xinit "$@" -- :"$tty"
    xauth remove :"$tty"
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ] && tty | grep -q tty; then
    SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    sed -n "$SEDCMD" "$XDG_CONFIG_HOME/X11/Xresources"  |
    while read -r n color; do
        [ "$n" -lt 16 ] && [ "$n" -gt 0 ] && printf "\e]P%X%s" "$n" "$color"
    done
fi

# use the prompt script comes with git
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1

# This command is in my own dotfiles repo
# shellcheck disable=SC1090
if [ -f ~/.local/bin/shell_prompt ]; then
    . ~/.local/bin/shell_prompt
    PS1='$(__bash_ps1 2> /dev/null)'
else
    PS1='$ '
fi

# History, https://unix.stackexchange.com/questions/18212
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:erasedups
HISTFILE="$XDG_DATA_HOME/bash_history"
[ -n "$BASH" ] && shopt -s histappend

# Disable ctrl-s and ctrl-q
stty -ixon
