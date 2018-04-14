#!/usr/bin/env sh

if [ x$1 = "xtest" ]
then
	d=./test
else
	d=~
fi

link()
{
	reallink $PWD/$1 $d/$2
}

reallink()
{
	if [ -e $2 ]
	then
        if [ -L $2 -a `readlink $2` = $PWD/$1 ]
        then
            printf "$2 is already a symlink to $1, "
        else
		    printf "The file/folder $2 exists already, "
		fi
		printf "do you want to replace it?\nBackup[b], Replace[R], Skip[s]: "
		read -r respond
		if [ x$respond = "xb" ]
		then
			echo "Backing up $2 as $2.bak"
			rm -rf $2.bak
			mv $2 $2.bak
			makelink $PWD/$1 $2
		fi
		
		if [ x$respond = "xr" -o x$respond = "x" ]
		then
			rm -rf $2
			makelink $PWD/$1 $2
		fi			
	else
		makelink $PWD/$1 $2
	fi
}

makelink()
{
	mkdir -p $(dirname $2)
	echo "Creating link $2 -> $1"
	ln -sf $1 $2
}

# link $1 $2
# $1 target file, relative path to $PWD
# $2 symlink file, relative path to $HOME
link bashrc .bashrc
link mpv .config/mpv
link aria2.conf .config/aria2/aria2.conf
