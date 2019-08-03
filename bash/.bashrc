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
alias yay="yay --color=auto"
# do not show temp fs
alias df="df -h -x tmpfs -x devtmpfs"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-video-plane-id=0"
# stow default to $HOME and turn on visual
alias stow="stow -t ~ -v"

# History, https://unix.stackexchange.com/questions/18212
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

# let vim to follow sym links
function vim() {
  args=()
  for i in $@; do
    if [[ -h $i ]]; then
      args+=`readlink $i`
    else
      args+=$i
    fi
  done

  /usr/bin/vim "${args[@]}"
}

# Console color theme, reuse .Xresources definitions
# Solarized color scheme
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
set -o vi
#Allows you to cd into directory merely by typing the directory name.
shopt -s autocd

# vcsi alias with template
alias vcsi="vcsi -t --template $HOME/.config/vcsi/template.txt"
