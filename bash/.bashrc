#!/bin/bash

if [ "$PS1" ] && [ -n "$BASH" ] && \
    [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Alias
alias sudo="doas"
# auto color
alias ls="ls --color=auto"
alias grep="grep --color=auto"
# ask when replacing files
alias mv="mv -iv"
alias cp="cp -iv"
# do not show *tmpfs
alias df="df -h -x tmpfs -x devtmpfs --output=source,fstype,size,used,avail,pcent,target"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-drmprime-video-plane=0"
# ranger under tty
alias cranger="ranger --cmd='set preview_images_method w3m'"
# vcsi alias with template
alias vcsi="vcsi -t --template \$HOME/.config/vcsi/template.txt"
# quiet newsboat
alias newsboat="newsboat -q"
# vim note
alias notes="lf \$HOME/Code/notes"
# pip update
pip_update() {
    pip list --user --outdated | tail -n+3 | cut -d " " -f 1 | xargs -r pip install --user --upgrade
}
# arch linux update
alias au="sudo pacman -Syu && ALL_PROXY=\$PROXY paru -Sua"

# timing function for dash
timeit() {
    # do 10 times of the timing itself and substract it later
    begin=$(date +%s%N);
    for _ in $(seq 9); do
        _=$(($(date +%s%N) - begin))
    done
    span=$((($(date +%s%N) - begin) / 10))

    begin=$(date +%s%N);
    eval "$@"
    echo $((($(date +%s%N) - begin - span) / 1000)) us
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ] && tty | grep -q tty; then
    cat "$XDG_CONFIG_HOME/X11/Xresources" |
    sed -n 's/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p' |
    while read -r n color; do
        [ "$n" -lt 16 ] && [ "$n" -gt 0 ] && printf "\e]P%X%s" "$n" "$color"
    done
fi

export PROXY="socks5h://localhost:1081"

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
# set vi mode keybinding
