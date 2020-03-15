#!/bin/bash

for p in "$HOME/.gem/ruby" "$HOME/.local/bin"; do
    if [ -d "$p" ] && ! echo "$PATH" | grep -q "$p"; then
        export PATH="$p:${PATH}"
    fi
done

if [ "$PS1" ] && [ -f /usr/share/bash-completion/bash_completion ]
then
    . /usr/share/bash-completion/bash_completion
fi

# shellcheck source=/dev/null
[ -f "$HOME/.extend.bashrc" ] && . "$HOME/.extend.bashrc"

# Environments
export EDITOR=vim
export VISUAL=vim
export NOTES_DIRECTORY="$HOME/Code/notes"
export FBFONT="/usr/share/kbd/consolefonts/ter-216n.psf.gz"

# Alias
# auto color
alias ls="ls --color=auto"
alias grep="grep --color=auto"
# ask when replacing files
alias mv="mv -i"
alias cp="cp -i"
# do not show *tmpfs
alias df="df -h -x tmpfs -x devtmpfs --output=source,fstype,size,used,avail,pcent,target"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-drmprime-video-plane=0"
# vcsi alias with template
alias vcsi="vcsi -t --template \$HOME/.config/vcsi/template.txt"
# fzf integrate with pacman and yay
fzfpacman()
{
    pacman -Slq | fzf -m -q "$*" --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}
fzfyay()
{
    yay -Slq | fzf -m -q "$*" --preview 'yay -Si {1}'| xargs -ro yay -S
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    while read -r n color; do
        if [ "$n" -lt 16 ]; then
            printf "\e]P%X%s" "$n" "$color"
        fi
    done <<- EOF
		$(sed -n "$_SEDCMD" "$HOME/.Xresources")
	EOF
    clear
fi

# shell prompt functions
__cwd_trim() {
    limit=24
    cwd=$(basename "$PWD")
    if [ ${#cwd} -gt $limit ]
    then
        printf "\[\e[1;33m\]%s...\[\e[0m\]" "$(echo "$cwd" | cut -c -"$limit")"
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
    count=$(( count_stop + count_run + count_done + count_kill ))
    if [ $count -gt 0 ]
    then
        printf " "
        [ "$count_stop" -gt 0 ] && printf "\[\e[33m\]S%s\[\e[0m\]" "$count_stop"
        [ "$count_run"  -gt 0 ] && printf "\[\e[32m\]R%s\[\e[0m\]" "$count_run"
        [ "$count_done" -gt 0 ] && printf "\[\e[34m\]D%s\[\e[0m\]" "$count_done"
        [ "$count_kill" -gt 0 ] && printf "\[\e[31m\]K%s\[\e[0m\]" "$count_kill"
    fi
}

__ssh_indicator() {
    [ -n "$SSH_CLIENT" ] && printf "\[\e[36m\][SSH]\[\e[0m\] "
}

__user_host() {
    printf "\[\e[35m\]%s@%s\[\e[0m\] " "$(whoami)" "$(hostname)"
}

__git_autostats() {
    if [ -f /tmp/git-autostats ]; then
        OLDIFS=$IFS
        unset IFS
        read -r uptodate ahead behind conflict < /tmp/git-autostats
        IFS=$OLDIFS
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
    __user_host
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
shopt -s histappend

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
