#!/bin/sh

USERID=$(id -u)
MANPATH=$(manpath 2> /dev/null)
# Environments
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export NOTES_DIRECTORY="$HOME/Code/notes"
export FBFONT="/usr/share/kbd/consolefonts/ter-216n.psf.gz"

# chinese input method
# gtk settings only for xorg, see .xprofile
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

# QT theme
export QT_QPA_PLATFORMTHEME=qt5ct

# SDL prefer wayland
export SDL_VIDEODRIVER=wayland,x11

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$USERID}"
export XDG_DATA_DIRS="${XDG_DATE_DIRS:-/usr/share:/usr/local/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"

export MANPATH="$XDG_DATA_HOME/man:$MANPATH"
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export XORGCONFIG="$XDG_CONFIG_HOME/xorg.conf"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export XAUTHORITY="${XAUTHORITY:-$XDG_DATA_HOME/Xauthority}"
export XCURSOR_THEME="Adwaita"
export XCURSOR_SIZE="24"
# less history
export LESSHISTFILE=-
# rlwrap history
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"
# elinks
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
# gnupg
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
# gtk2
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
# python: ipython, jupyter, pylint
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/ipython"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
# mathematica
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME/Mathematica"
# passwordstore
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export PASSWORD_STORE_GENERATED_LENGTH=15
# mplayer
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
# terminfo
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
# grip (markdown render)
export GRIPHOME="$XDG_CONFIG_HOME/grip"
# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
# rxvt
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd"
# abduco
export ABDUCO_SOCKET_DIR="$XDG_RUNTIME_DIR"
# ruby bundle/gem
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
# dvdcss
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
# ex/vi/vim/nvim
export EXINIT=":source $XDG_CONFIG_HOME/ex/exrc"
export VIMINIT=":source $XDG_CONFIG_HOME/vim/vimrc"
# libice
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
# nodejs
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_PACKAGES="$XDG_DATA_HOME/npm"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
# rand
export RANDFILE="$XDG_CACHE_HOME/openssl_rnd"
# dialog
export DIALOGRC="$XDG_CONFIG_HOME/dialog/dialogrc"
# lynx
export LYNX_CFG="$XDG_CONFIG_HOME/lynx/lynx.cfg"
export LYNX_LSS="$XDG_CONFIG_HOME/lynx/lynx.lss"
# maxima
export MAXIMA_USERDIR="$XDG_DATA_HOME/maxima"
# android
export ANDROID_PREFS_ROOT="$XDG_CONFIG_HOME/android"
export ADB_KEYS_PATH="$ANDROID_PREFS_ROOT"
export ANDROID_HOME="$XDG_DATA_HOME"/android
# java applications
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
# rust cargo
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
# texlive
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
# proxychains-ng
export PROXYCHAINS_CONF_FILE="$XDG_CONFIG_HOME/proxychains-ng/proxychains.conf"
export PROXY="socks5://proxy-host:1081"
# dash interactive mode
export ENV="$HOME/.bashrc"
# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# BibTool
export BIBTOOLRSC="$XDG_CONFIG_HOME/bibtool/resource"
# TMSU
export TMSU_DB="$XDG_DATA_HOME/tmsu.db"
# fv the fits viewer
export FVTMP="$XDG_CACHE_HOME/fvtmp"
# pspg
export PSPG_CONF="$XDG_CONFIG_HOME/pspg.conf"
# Kivy
export KIVY_HOME="$XDG_CONFIG_HOME/kivy"
# W3M
export W3M_DIR="$XDG_DATA_HOME/w3m"
# wget
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
# bemenu
export BEMENU_OPTS="-l 15 -c -B 2 -H 28 -W 0.5 --fn 'Monospace 12' --fixed-height"
# nuget
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages

# PATH
add_to_path() {
    [ "$PATH" = "${PATH#*"$*"}" ] && export PATH="$*:${PATH}"
}
add_to_path "$HOME/.local/bin"
add_to_path "$NPM_PACKAGES/bin"
add_to_path "$XDG_DATA_HOME"/gem/ruby/*/bin
