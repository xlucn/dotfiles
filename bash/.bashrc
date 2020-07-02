#!/bin/bash

for p in "$HOME/.gem/ruby" "$HOME/.local/bin" "$HOME/.local/share/npm/bin"; do
    if [ -d "$p" ] && ! echo "$PATH" | grep -q "$p"; then
        export PATH="$p:${PATH}"
    fi
done

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
# cam
alias mpvcam="mpv av://v4l2:/dev/video0 --profile=low-latency --untimed"
alias mplayercam="mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 30"
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
__cwd_trim() {
    printf "\[\e[1;33m\]"
    limit=20
    cwd=$(basename "$PWD")
    if [ ${#cwd} -gt $limit ]; then
        printf "%s ..." "$(echo "$cwd" | cut -c -"$((limit - 4))")"
    else
        printf "%s" "$cwd"
    fi
    # lf indicator -- if you are in lf file manager
    [ -n "$LF_LEVEL" ] && printf " (LF:%s)" "$LF_LEVEL"
    # ranger indicator -- if you are in ranger file manager
    [ -n "$RANGER_LEVEL" ] && printf " (RANGER:%s)" "$RANGER_LEVEL"
    printf "\[\e[0m\]"
}

__jobs_count() {
    jobs_info=$(jobs)
    count_stop=$(echo "$jobs_info" | grep -Ec "Stopped|Suspended")
    count_run=$(echo "$jobs_info" | grep -Ec "Running")
    count_done=$(echo "$jobs_info" | grep -Ec "Done")
    count_kill=$(echo "$jobs_info" | grep -Ec "Killed|Terminated")
    count=$(( count_stop + count_run + count_done + count_kill ))
    if [ $count -gt 0 ]; then
        printf " "
        [ "$count_stop" -gt 0 ] && printf "\[\e[33m\]S%s\[\e[0m\]" "$count_stop"
        [ "$count_run"  -gt 0 ] && printf "\[\e[32m\]R%s\[\e[0m\]" "$count_run"
        [ "$count_done" -gt 0 ] && printf "\[\e[34m\]D%s\[\e[0m\]" "$count_done"
        [ "$count_kill" -gt 0 ] && printf "\[\e[31m\]K%s\[\e[0m\]" "$count_kill"
    fi
}

__user_host() {
    printf "\[\e[35m\]%s@%s\[\e[0m\] " "$(whoami)" "$(hostname)"
}

__ssh_indicator() {
    if [ -n "$SSH_CLIENT" ]; then
        printf "\[\e[36m\][SSH]\[\e[0m\] "
        __user_host
    fi
}

__git_autostats() {
    if [ -f /tmp/git-autostats ]; then
        read -r uptodate ahead behind conflict < /tmp/git-autostats
        printf " ["
        [ "$uptodate" -gt 0 ] && printf "\[\e[34m\]%s=\[\e[0m\]" "$uptodate"
        [ "$ahead"    -gt 0 ] && printf "\[\e[32m\]%s+\[\e[0m\]" "$ahead"
        [ "$behind"   -gt 0 ] && printf "\[\e[33m\]%s-\[\e[0m\]" "$behind"
        [ "$conflict" -gt 0 ] && printf "\[\e[31m\]%s±\[\e[0m\]" "$conflict"
        printf "]"
    else
        git autostats -u > /dev/null 2>&1
    fi
}

__before_git() {
    __ssh_indicator
    __cwd_trim
    __jobs_count
    __git_autostats
}
__after_git() {
    printf " \[\e[1;33m\]\$\[\e[0m\] "
}

# use the prompt script somes with git
if ! command -v __git_ps1 > /dev/null 2>&1; then
    . /usr/share/git/completion/git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "$(__before_git)" "$(__after_git)"'

# History, https://unix.stackexchange.com/questions/18212
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:erasedups
HISTFILE="$XDG_DATA_HOME/bash_history"
shopt -s histappend

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
