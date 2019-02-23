[ -d ~/maple2017 ] && PATH=~/maple2017/bin:$PATH
[ -d ~/.gem/ruby/ ] && PATH="~/.gem/ruby/2.6.0/bin":$PATH
[ -d ~/.local/bin ] && PATH=/home/oliver/.local/bin:$PATH

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[ -f ~/.extend.bashrc ] && . ~/.extend.bashrc

# Environments
export editor=vim

# Alias
# auto color
alias ls="ls --color=auto"
alias pacman="pacman --color=auto"
# do not show temp fs
alias df="df -h -x tmpfs -x devtmpfs"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi-copy --drm-video-plane-id=0"

# my customized du
function sdu() { du -ahx -d 1 ${*} 2>/dev/null | sort -h; }

# ps and grep
function psg() { ps -ef | grep ${*}; }

# Console color theme
# Solarized color scheme
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "\e]P0073642"
  /bin/echo -e "\e]P1dc322f"
  /bin/echo -e "\e]P2859900"
  /bin/echo -e "\e]P3b58900"
  /bin/echo -e "\e]P4268bd2"
  /bin/echo -e "\e]P5d33682"
  /bin/echo -e "\e]P62aa198"
  /bin/echo -e "\e]P7eee8d5"
  /bin/echo -e "\e]P8002b36"
  /bin/echo -e "\e]P9cb4b16"
  /bin/echo -e "\e]PA586e75"
  /bin/echo -e "\e]PB657b83"
  /bin/echo -e "\e]PC839496"
  /bin/echo -e "\e]PD6c71c4"
  /bin/echo -e "\e]PE93a1a1"
  /bin/echo -e "\e]PFfdf6e3"
  # get rid of artifacts
  clear
fi

# powerline setup
command -v powerline &> /dev/null
powerline_check=$?
if [ $powerline_check -eq 0 ]
then
    powerline_root=/usr/lib/python3.7/site-packages
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . $powerline_root/powerline/bindings/bash/powerline.sh
fi
