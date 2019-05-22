[ -d ~/.gem/ruby/ ] && PATH="~/.gem/ruby/2.6.0/bin":$PATH
[ -d ~/.local/bin ] && PATH=~/.local/bin:$PATH

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[ -f ~/.extend.bashrc ] && . ~/.extend.bashrc

# Environments
export EDITOR=vim
export VISUAL=vim

# Alias
# auto color
alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
# do not show temp fs
alias df="df -h -x tmpfs -x devtmpfs"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi-copy --drm-video-plane-id=0"
# stow default to $HOME and turn on visual
alias stow="stow -t ~ -v"

PS1='[\u@\h \W]\$ '
# my customized du
function sdu() { du -ahx -d 1 ${*} 2>/dev/null | sort -h; }

# ps and grep
function psg() { ps -ef | grep ${*}; }

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

# set vi mode keybinding
set -o vi
