[ -d ~/maple2017 ] && PATH=~/maple2017/bin:$PATH
[ -d ~/.gem/ruby/ ] && PATH="~/.gem/ruby/2.5.0/bin":$PATH
[ -d ~/.local/bin ] && PATH=/home/oliver/.local/bin:$PATH

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export editor=vim

# auto color
alias ls="ls --color=auto"
alias pacman="pacman --color=auto"

# my customized du
function sdu() {
    du -ahx -d 1 ${*} 2>/dev/null | sort -h;
}

# Shell prompt
export PS1="\[\033[38;5;46m\]\u\[$(tput sgr0)\]\[\033[38;5;63m\]@\[$(tput sgr0)\]\[\033[38;5;200m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;6m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;13m\]\\$\[$(tput sgr0)\] "

# Tomorrow color scheme
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P01d1f21
  \e]P1cc6666
  \e]P2b5bd68
  \e]P3f0c674
  \e]P481a2be
  \e]P5b294bb
  \e]P68abeb7
  \e]P7c5c8c6
  \e]P8969896
  \e]P9cc6666
  \e]PAb5bd68
  \e]PBf0c674
  \e]PC81a2be
  \e]PDb294bb
  \e]PE8abeb7
  \e]PFffffff
  "
  # get rid of artifacts
  clear
fi

# powerline
command -v powerline &> /dev/null
powerline_check=$?
if [ $powerline_check -eq 0 ]
then
    powerline_root=/usr/lib/python3.6/site-packages
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . $powerline_root/powerline/bindings/bash/powerline.sh
fi
