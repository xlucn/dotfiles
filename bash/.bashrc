#! /bin/bash

[ -d ~/.gem/ruby/ ] && export PATH="${PATH}:$HOME/.gem/ruby/2.6.0/bin"
[ -d ~/.local/bin ] && export PATH="${PATH}:$HOME/.local/bin"

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
# shellcheck source=/dev/null
[ -f ~/.extend.bashrc ] && . "$HOME/.extend.bashrc"

# Environments
export EDITOR=vim
export VISUAL=vim
# add mouse support after less version 550
less_version=$(less -V | grep -E "^less [[:digit:]]+" | cut -d" " -f 2)
if [ "$less_version" -ge 550 ]
then
    export LESS="--mouse --wheel-lines=5"
fi

# Alias
# auto color
alias ls="ls --color=auto"
alias grep="grep --color=auto"
# ask when replacing files
alias mv="mv -i"
# do not show *tmpfs
alias df="df -h -x tmpfs -x devtmpfs"
# mpv under virtual console using drm
alias cmpv-gpu="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-video-plane-id=0"
alias cmpv="mpv --vo=drm"
# vcsi alias with template
alias vcsi="vcsi -t --template \$HOME/.config/vcsi/template.txt"

PS1='[\u@\h \W]\$ '

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    while read -r i < <(\
        sed -n "$_SEDCMD" "$HOME/.Xresources" | \
        awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}')
    do
        echo -en "$i"
    done
    clear
fi

__cwd_trim() {
    limit=24
    cwd=$(basename "$PWD")
    if [ ${#cwd} -gt $limit ]
    then
        printf "\[\e[1;33m\]%s...\[\e[0m\]" "${cwd:0:$limit}"
    else
        printf "\[\e[1;33m\]%s\[\e[0m\]" "$cwd"
    fi
}

__jobs_count() {
    jobs_info=$(jobs)
    count_stop=$(echo "$jobs_info" | grep -Ec "Stopped|Suspended")
    count_run=$(echo "$jobs_info" | grep -Ec "Running")
    count_done=$(echo "$jobs_info" | grep -Ec "Done")
    count_kill=$(echo "$jobs_info" | grep -Ec "Killed|Terminated")
    count=$(( "$count_stop" + "$count_run" + "$count_done" + "$count_kill" ))
    if [ $count -gt 0 ]
    then
        printf " "
        if [ "$count_stop" -gt 0 ]; then printf "\[\e[33mT%s\[\e[0m\]" "$count_stop"; fi
        if [ "$count_run"  -gt 0 ]; then printf "\[\e[32mR%s\[\e[0m\]" "$count_run"; fi
        if [ "$count_done" -gt 0 ]; then printf "\[\e[34mD%s\[\e[0m\]" "$count_done"; fi
        if [ "$count_kill" -gt 0 ]; then printf "\[\e[31mK%s\[\e[0m\]" "$count_kill"; fi
    fi
}

__ssh_indicator() {
    if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ]
    then
        printf "\[\e[36m\][SSH]\[\e[0m\] "
    fi
}

__before_git() {
    printf "%s\[\e[35m\]%s@%s\[\e[0m\] %s%s" \
           "$(__ssh_indicator)" \
           "$(whoami)" \
           "$(hostname)" \
           "$(__cwd_trim)" \
           "$(__jobs_count)"
}
__after_git() {
    printf " \[\e[1;33m\]\$\[\e[0m\] "
}

# use the prompt script somes with git
if [ -z "$(type -t __git_ps1)" ]
then
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
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
set -o vi
#Allows you to cd into directory merely by typing the directory name.
shopt -s autocd
