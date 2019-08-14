#!/usr/bin/env bash
# ~/.bash_profile
#
if [[ -f ~/.bashrc ]]
then
    . ~/.bashrc
fi

if [[ -f ~/.extend.bash_profile ]]
then
    . ~/.extend.bash_profile
fi
