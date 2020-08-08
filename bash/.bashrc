#!/bin/bash

if [ "$PS1" ] && [ -f /usr/share/bash-completion/bash_completion ]
then
    . /usr/share/bash-completion/bash_completion
fi

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
# vimwiki note
alias vimnote="vim +VimwikiIndex"
# pip update
pip_update() {
    pip list --user --outdated | tail -n+3 | cut -d " " -f 1 | xargs pip install --user --upgrade
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    sed -n "$_SEDCMD" "$HOME/.Xresources" | while read -r n color; do
        [ "$n" -lt 16 ] && printf "\e]P%X%s" "$n" "$color"
    done
    clear
fi

# shell prompt functions
red="\001\033[31m\002"
green="\001\033[32m\002"
yellow="\001\033[33m\002"
blue="\001\033[34m\002"
magenta="\001\033[35m\002"
cyan="\001\033[36m\002"
reset="\001\033[0m\002"
boldyellow="\001\033[1;33m\002"

if ! command -v __git_ps1 > /dev/null 2>&1; then
    # shellcheck disable=SC1090 # source location
    . "$HOME/.config/git/git-prompt.sh"
fi

__ssh_indicator() {
    if [ -n "$SSH_CLIENT" ]; then
        printf "${cyan}[SSH] $magenta%s@%s$reset " "$(whoami)" "$(hostname)"
    fi
}

__cwd_trim() {
    limit=20
    cwd="$1"
    if [ ${#cwd} -gt $limit ]; then
        printf "%s …" "$(echo "$cwd" | cut -c -"$((limit - 2))")"
    else
        printf "%s" "$cwd"
    fi
    # lf indicator -- if you are in lf file manager
    [ -n "$LF_LEVEL" ] && printf " (LF:%s)" "$LF_LEVEL"
    # ranger indicator -- if you are in ranger file manager
    [ -n "$RANGER_LEVEL" ] && printf " (RANGER:%s)" "$RANGER_LEVEL"
}

__curdir() {
    printf "$boldyellow%s$reset" "$(__cwd_trim "$(basename "$(pwd)")")"
}

__jobcounts() {
    jobcount=$(jobs -p | wc -l)
    [ "$jobcount" -gt 0 ] && printf " $green(jobs:%s)$reset" "$jobcount"
}

__git_autostats() {
    if [ -f /tmp/git-autostats ]; then
        read -r uptodate ahead behind conflict < /tmp/git-autostats
        printf " ["
        [ "$uptodate" -gt 0 ] && printf "$blue%s=$reset" "$uptodate"
        [ "$ahead"    -gt 0 ] && printf "$green%s+$reset" "$ahead"
        [ "$behind"   -gt 0 ] && printf "$yellow%s-$reset" "$behind"
        [ "$conflict" -gt 0 ] && printf "$red%s±$reset" "$conflict"
        printf "]"
    else
        git autostats -u > /dev/null 2>&1
    fi
}

__gitprompt() {
    printf "$(
    __git_ps1 " (%s)" |
    sed -e "s/%/%%/g" \
        -e "s/\\\\\\[/\\\\001/g" \
        -e "s/\\\\\\]/\\\\002/g" \
        -e "s/\\\\\\e/\\\\033/g"
    )%s"
}

__shell_prompt() {
    __ssh_indicator
    __curdir
    __jobcounts
    __git_autostats
    __gitprompt
    printf "$boldyellow %s $reset" "$"
}

# use the prompt script comes with git
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=1

PS1='$(__shell_prompt)'

# History, https://unix.stackexchange.com/questions/18212
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:erasedups
HISTFILE="$XDG_DATA_HOME/bash_history"
shopt -s histappend

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
