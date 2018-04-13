# my customized du
function sdu() { 
    du -ahx -d 1 ${*} 2>/dev/null | sort -h;
}

# auto color
alias ls='ls --color=auto'
alias pacman='pacman --color=auto'
alias pacaur='pacaur --color=auto'

# Shell prompt
export PS1="\[\033[38;5;46m\]\u\[$(tput sgr0)\]\[\033[38;5;63m\]@\[$(tput sgr0)\]\[\033[38;5;200m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;6m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;13m\]\\$\[$(tput sgr0)\] "

# add .local/bin to PATH
PATH=/home/oliver/.local/bin:/home/oliver/.gem/ruby/2.5.0/bin/:$PATH
