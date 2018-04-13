[ -d ~/maple2017 ] && PATH=~/maple2017/bin:$PATH
[ -d ~/.gem/ruby/ ] && PATH="~/.gem/ruby/2.5.0/bin":$PATH
[ -d ~/.local/bin ] && PATH=/home/oliver/.local/bin:$PATH

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export editor=vim

# auto color
alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
alias aurman="pacaur --color=auto"

# my customized du
function sdu() { 
    du -ahx -d 1 ${*} 2>/dev/null | sort -h;
}

# Shell prompt
export PS1="\[\033[38;5;46m\]\u\[$(tput sgr0)\]\[\033[38;5;63m\]@\[$(tput sgr0)\]\[\033[38;5;200m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;6m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;13m\]\\$\[$(tput sgr0)\] "

