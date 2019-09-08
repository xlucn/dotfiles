#! /bin/sh

[ -d ~/.gem/ruby/ ] && export PATH="${PATH}:$HOME/.gem/ruby/2.6.0/bin"
[ -d ~/.local/bin ] && export PATH="${PATH}:$HOME/.local/bin"

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[ -f ~/.extend.bashrc ] && . ~/.extend.bashrc

# Environments
export EDITOR=vim
export VISUAL=vim
# python start up script
export PYTHONSTARTUP=~/.pythonrc.py

# Alias
# auto color
alias ls="ls --color=auto"
alias mv="mv -i"
# do not show temp fs
alias df="df -h -x tmpfs -x devtmpfs"
# mpv under virtual console using drm
alias cmpv-gpu="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-video-plane-id=0"
alias cmpv="mpv --vo=drm"
# vcsi alias with template
alias vcsi="vcsi -t --template $HOME/.config/vcsi/template.txt"

# History, https://unix.stackexchange.com/questions/18212
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

PS1='[\u@\h \W]\$ '

# my customized du
function sdu() { du -ahx -d 1 ${*} 2>/dev/null | sort -h; }

# ps and grep
function psg() { ps -ef | grep ${*}; }

# count journal sources
function journalcount()
{
    journalctl -b | cut -d\  -f 5 | cut -d\[ -f 1 | sort | uniq -c | sort -h
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi

function __cwd_trim() {
    limit=24
    cwd=$(basename "$PWD")
    if [[ ${#cwd} -gt $limit ]]
    then
        printf "\[\e[1;33m\]${cwd:0:$limit}...\[\e[0m\]"
    else
        printf "\[\e[1;33m\]$cwd\[\e[0m\]"
    fi
}

function __jobs_count() {
    jobs_info=`jobs`
    count_stop=`echo $jobs_info | grep -E "Stopped|Suspended" | wc -l`
    count_run=`echo $jobs_info | grep -E "Running" | wc -l`
    count_done=`echo $jobs_info | grep -E "Done" | wc -l`
    count_kill=`echo $jobs_info | grep -E "Killed|Terminated" | wc -l`
    count=`expr $count_stop + $count_run + $count_done + $count_kill`
    if [[ $count > 0 ]]
    then
        printf " "
        if [[ $count_stop > 0 ]]; then printf "\[\e[33mT$count_stop\[\e[0m\]"; fi
        if [[ $count_run > 0 ]]; then printf "\[\e[32mR$count_run\[\e[0m\]"; fi
        if [[ $count_done > 0 ]]; then printf "\[\e[34mD$count_done\[\e[0m\]"; fi
        if [[ $count_kill > 0 ]]; then printf "\[\e[31mK$count_kill\[\e[0m\]"; fi
    fi
}

function __ssh_indicator() {
    if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT ]]
    then
        printf "\[\e[34m\][SSH]\[\e[0m\]"
    fi
}

function __before_git() {
    printf "\[\e[35m\]$(whoami)@$(hostname)\[\e[0m\]`__ssh_indicator` `__cwd_trim``__jobs_count`"
}
function __after_git() {
    printf " \[\e[1;33m\]\$\[\e[0m\] "
}

# use the prompt script somes with git
if [[ -z `type -t __git_ps1` ]]
then
    source /usr/share/git/completion/git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "$(__before_git)" "$(__after_git)"'

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
set -o vi
#Allows you to cd into directory merely by typing the directory name.
shopt -s autocd
