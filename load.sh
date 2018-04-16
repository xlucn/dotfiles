#!/usr/bin/env sh

originalfile=${1}
basefile=$(basename $1)
localefile=${basefile#*.}
mv $originalfile $localefile
