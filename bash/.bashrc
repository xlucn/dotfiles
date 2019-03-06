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

PS1='[\u@\h \W]\$ '
# my customized du
function sdu() { du -ahx -d 1 ${*} 2>/dev/null | sort -h; }

# ps and grep
function psg() { ps -ef | grep ${*}; }

# Console color theme, reuse .Xresources definitions
# Solarized color scheme
#if [ "$TERM" = "linux" ]; then
    #_SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    #for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        #echo -en "$i"
    #done
    #clear
#fi

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
