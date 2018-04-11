[ -d ~/maple2017 ] && PATH=~/maple2017/bin:$PATH
[ -d ~/.gem/ruby/ ] && PATH="~/.gem/ruby/2.5.0/bin":$PATH

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

# pacaur conf
export editor=vim

# auto color
alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
alias pacaur="pacaur --color=auto"
