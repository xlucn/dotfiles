#!/usr/bin/env sh

makelink()
{
	mkdir -p $(dirname $2)
	echo "Creating link $2 -> $1"
	ln -sf $1 $2
}

link()
{
	if [ -e $2 ]
	then
		echo -e "The file/folder $2 exists already, do you want to replace it?\nBackup[b], No[n], Replace[R]"
		read respond
		if [ x$respond = "xb" ]
		then
			echo "Backing up $2 as $2.bak"
			mv $2 $2.bak
		fi
		
		if [ ! -e $2 -o x$respond = "xr" -o x$respond = "x" ]
		then
			makelink $PWD/$1 $2
		fi			
	else
		makelink $PWD/$1 $2
	fi
}

if [ x$1 = "xtest" ]
then
	d=./test
else
	d=~
fi

link bashrc $d/.bashrc
link mpv $d/.config/mpv
link aria2.conf $d/.config/aria2/aria2.conf
