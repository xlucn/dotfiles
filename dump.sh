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
        # check if there is already a symlink to the target, skip by default
        if [ -L $2 -a "$(readlink $2)" = $1 ]
        then
            printf "$2 is already a symlink to $1, "
            printf "do you want to replace it?\n"
            printf "Backup[b], Replace[r], Skip[S]: "
            read -r respond
            [ x$respond = "x" ] && respond=s
        # it is already a symlink but to different target, backup by default
        elif [ -L $2 -a "$(readlink $2)" != $1 ]
        then
            printf "$2 is a symlink but pointing to `readlink $2`, "
            printf "do you want to replace it?\n"
            printf "Backup[B], Replace[r], Skip[s]: "
            read -r respond
            [ x$respond = "x" ] && respond=b
        # it is a normal file or folder, replace by default(treat it as old file, replace with new)
        else
            printf "The file/folder $2 exists already, "
            printf "do you want to replace it?\n"
            printf "Backup[b], Replace[R], Skip[s]: "
            read -r respond
            [ x$respond = "x" ] && respond=r
        fi
        
        # Backup file
        if [ x$respond = "xb" ]
        then
            echo "Backing up $2 as $2.bak"
            rm -rf $2.bak
            mv $2 $2.bak
            makelink $1 $2
        fi
        
        # Replace file
        if [ x$respond = "xr" ]
        then
            rm -rf $2
            makelink $1 $2
        fi            
    else
        makelink $1 $2
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
link vimrc .vimrc
link Xresources .Xresources
