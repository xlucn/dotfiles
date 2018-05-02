#!/usr/bin/env sh

help()
{
    echo -e "sh dotfiles.sh [-f <file>] [test] dump/load [<from> [<to>]]

-f filelist: If given, the file <file> will be used instead of default
    'filelist'.

test: If given, just treat ./test folder as \$HOME so it won't mess up
    the home directory. Mainly for testing.

dump: create link file in target location, used when setting up a new system
    dump:
        read from filelist
    dump <from>:
        <from> should be a local file.
        The script will scan through filelist looking for the same file and
        determine the correspounding target location.
    dump <from> <to>:
        <from> should be a local file, <to> should be a relative path to \$HOME.
        The script will create a link file to <from> at location <to>.

load: move a target file to repo directory, used when adding a new file/folder
    load:
        With no <from> argument, the script will scan 'filelist' file to look
        for files that are not loaded to local repo and load them.
    load <from>:
        <from> is the file you want to put in repo. The script will move the
        <from> file to current repo directory and rename it without prefixing
        '.' and folder path.
        e.g.
            <from>: \$HOME/.vimrc       -> vimrc
            <from>: \$HOME/.config/mpv  -> mpv
    load <from> <to>
        manually specify the local file/directory name with <to>. The rest is
        the same as without <to>."
}

usage()
{
    echo -e "Usage:
    sh dotfiles.sh [-f <file>] [test] dump/load [<from> [<to>]]
    For more information, see 'sh dotfiles.sh help'"
}

load()
{
    if [ $TEST == 1 ]
    then
        f=$testdir
    else
        f=$PWD
    fi

    if [[ $1 == /* ]]
    then
        d=
    else
        d=$HOME
    fi

    move $d/$1 $f/$2
}

move()
{
    if [ ! -e $1 ]
    then
        echo "[NotExist]: The file $1 does not exist."
    elif [ -L $1 -a "$(readlink $1)" = $2 ]
    then
        echo "[Skipping]: Exists already: $1 -> $2"
    elif [ -L $1 -a "$(readlink $1)" != $2 ]
    then
        printf "[LinkFile]: $1 is a link to $(readlink $1). "
        printf "Do you want to"

    elif [ ! -e $2 ]
    then
        movefile $1 $2
    else
        if [ -L $2 ]
        then
            printf "[Conflict]: $2 is a link file, "
        elif [ -d $2 ]
        then
            printf "[Conflict]: The folder $2 exists already, "
        elif [ -f $2 ]
        then
            printf "[Conflict]: The file $2 exists already, "
        fi
        printf "do you want to replace it?\n"
        printf "Backup[b], Replace[R], Skip[s]: "
        read -r respond
        [ x$respond = "x" ] && respond=r
    fi
     # Backup file
    if [ x$respond = "xb" ]
    then
        echo "[Back up ]: $2 -> $2.bak"
        rm -rf $2.bak
        mv $2 $2.bak
        movefile $1 $2
    fi
     # Replace file
    if [ x$respond = "xr" ]
    then
        rm -rf $2
        movefile $1 $2
    fi
}

movefile()
{
    mkdir -p $(dirname $2)
    echo "[Moving  ]: $1 -> $2"
    cp $1 $2
}

dump()
{
    if [ $TEST == 1 ]
    then
        d=$testdir
    elif [[ $2 == /* ]]
    then
        d=
    else
        d=$HOME
    fi

    link $PWD/$1 $d/$2
}

link()
{
    if [ ! -e $1 ]
    then
        echo "[NotExist]: $1 does not exist!"
    elif [ ! -e $2 ]
    then
        makelink $1 $2
    # check if there is already a symlink to the target, skip
    elif [ -L $2 -a "$(readlink $2)" = $1 ]
    then
        printf "[Skipping]: Exists already, $2 -> $1\n"
    # it is already a symlink but to different target, backup by default
    elif [ -L $2 -a "$(readlink $2)" != $1 ]
    then
        printf "[Conflict]: $2 is a symlink but pointing to `readlink $2`, "
        printf "do you want to replace it?\n"
        printf "Backup[B], Replace[r], Skip[s]: "
        read -r respond
        [ x$respond = "x" ] && respond=b
    # it is a normal file or folder, replace by default
    else
        if [ -d $2 ]
        then
            printf "[Conflict]: The folder $2 exists already, "
        elif [ -f $2 ]
        then
            printf "[Conflict]: The file $2 exists already, "
        fi
        printf "do you want to replace it?\n"
        printf "Backup[b], Replace[R], Skip[s]: "
        read -r respond
        [ x$respond = "x" ] && respond=r
    fi

    # Backup file
    if [ x$respond = "xb" ]
    then
        echo "[Back up ]: $2 -> $2.bak"
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
}

makelink()
{
    mkdir -p $(dirname $2)
    echo "[Linking ]: $2 -> $1"
    ln -sf $1 $2
}


testdir=./test
filelist=filelist

if [ x$1 = "x-f" ]
then
    filelist=$2
    shift 2
fi

if [ x$1 = "xtest" ]
then
    TEST=1
    shift
else
    TEST=0
fi

case x$1 in
    "xdump"|"xload")
        # no <from> argument, scan the file
        if [ x$2 = "x" ]
        then
            # use another unit to read
            exec 3<> temp.txt
            # skip comments starting with '#'
            grep -v '^#' $filelist >&3
            while read from to <&3
            do
                if [ x$1 = "xdump" ]
                then
                    dump $from $to
                elif [ x$1 = "xload" ]
                then
                    load $to $from
                fi
            done 3<temp.txt
            rm temp.txt
        # <from> file is given
        elif [ x$1 = "xdump" ]
        then
            if [ x$3 = "x" ]
            then
                # search the filelist
                temp=($(grep -v '^#' $filelist | grep "^$2"))
                t=${temp[1]}
                if [ x$t != "x" ]
                then
                    dump $2 $t
                else
                    echo "[NotExist]: $2 \
is not in the first column of the file $filelist."
                    exit 1
                fi
            else
                dump $2 $3
            fi
        elif [ x$1 = "xload" ]
        then
            from=$2
            to=$3
            if [ x$to = "x" ]
            then
                basefile=$(basename $2)
                to=${basefile#*.}
            fi
            load $from $to
        fi
        ;;
    "xhelp")
        help
        exit 0
        ;;
    *)
        usage
        exit 0
esac

