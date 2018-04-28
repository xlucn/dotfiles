#!/usr/bin/env bash
# ~/.bash_profile
#

[[ -f ~/.extend.bash_profile ]] && . ~/.extend.bash_profile
[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

command -v powerline &> /dev/null
powerline_check=$?
if [ $powerline_check -eq 0 ]
then
    powerline-daemon -q
fi

