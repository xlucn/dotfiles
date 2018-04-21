#!/usr/bin/env sh

usage="sh dotfile.sh [test] dump/load [<from> [<to>]]"

if [ x$1 = "xtest" ]
then
    d=./test
    shift
else
    d=$HOME
fi

case x$1 in
    "xdump")
        # dump ......
        ;;
    "xload")
        # link ......
        ;;
    *)
        echo $usage
esac

load()
{
    originalfile=$1
    basefile=$(basename $1)
    localefile=${basefile#*.}
    mv $originalfile $localefile
}

link()
{
    if [ -e $2 ]
    then
        # check if there is already a symlink to the target, skip
        if [ -L $2 -a "$(readlink $2)" = $1 ]
        then
            printf "$2 is already a symlink to $1, skipping\n"
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
            if [ -d $2 ]
            then
                printf "The folder $2 exists already, "
            elif [ -f $2 ]
            then
                printf "The file $2 exists already, "
            fi
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

# link $PWD/$1 $d/$2
