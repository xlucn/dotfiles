#!/bin/bash

if [ "$PS1" ] && [ -f /usr/share/bash-completion/bash_completion ]
then
    . /usr/share/bash-completion/bash_completion
fi

# shellcheck disable=SC1090
. "$HOME/.profile"

# Alias
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
    pip list --user --outdated | tail -n+3 | cut -d " " -f 1 | xargs pip install --user --upgrade
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    sed -n "$_SEDCMD" "$HOME/.Xresources" | while read -r n color; do
        [ "$n" -lt 16 ] && [ "$n" -gt 0 ] && printf "\e]P%X%s" "$n" "$color"
    done
fi

# This command is in my own dotfiles repo
PS1='$(shell_prompt)'

# History, https://unix.stackexchange.com/questions/18212
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:erasedups
HISTFILE="$XDG_DATA_HOME/bash_history"
shopt -s histappend

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
