#!/usr/bin/env bash
# ~/.bash_profile
#

command -v powerline &> /dev/null
powerline_check=$?
if [ $powerline_check -eq 0 ]
then
    powerline-daemon -q
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
