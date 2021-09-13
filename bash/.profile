#!/bin/sh

HOME=${HOME%%/}
# Environments
export EDITOR=vim
export VISUAL=vim
export NOTES_DIRECTORY="$HOME/Code/notes"
export FBFONT="/usr/share/kbd/consolefonts/ter-216n.psf.gz"

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
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
# ruby bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
# dvdcss
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
# vim
export MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
export MYGVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
export EXINIT=":source $XDG_CONFIG_HOME/ex/exrc"
export VIMINIT=":source $MYVIMRC"
# libice
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
# nodejs
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_PACKAGES="$XDG_DATA_HOME/npm"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
unset MANPATH
MANPATH=$(manpath)
export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
# rand
export RANDFILE="$XDG_CACHE_HOME/openssl_rnd"
# dialog
export DIALOGRC="$XDG_CONFIG_HOME/dialog/dialogrc"
# lynx
export LYNX_CFG="$XDG_CONFIG_HOME/lynx/lynx.cfg"
export LYNX_LSS="$XDG_CONFIG_HOME/lynx/lynx.lss"
# maxima
export MAXIMA_USERDIR="$XDG_CONFIG_HOME/maxima"
# android
export ANDROID_PREFS_ROOT="$XDG_CONFIG_HOME/android"
export ADB_KEYS_PATH="$ANDROID_PREFS_ROOT"
# java applications
export _JAVA_AWT_WM_NONREPARENTING=1
export JDK_JAVA_OPTIONS="
    -Dawt.useSystemAAFontSettings=on
    -Dswing.aatext=true
    -Dsun.java2d.opengl=true
    -Dsun.java2d.uiScale=2
    -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
    -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
# rust cargo
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
# texlive
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
# proxychains-ng
export PROXYCHAINS_CONF_FILE="$XDG_CONFIG_HOME/proxychains-ng/proxychains.conf"
# dash interactive mode
export ENV=$HOME/.bashrc

# PATH
add_to_path() {
    if [ -d "$1" ] && [ "$PATH" = "${PATH%$1*}" ]; then
        export PATH="$1:${PATH}"
    fi
}
add_to_path "$HOME/.local/bin"
add_to_path "$NPM_PACKAGES/bin"
add_to_path "$XDG_DATA_HOME"/gem/ruby/*/bin

# Set icons in lf
export LF_ICONS="\
.git=󰊢:\
Desktop=󰇄:\
Documents=󰠮:\
Downloads=󰉍:\
Dotfiles=󰇣:\
Dropbox=󰇣:\
Music=󰝚:\
Pictures=󰉏:\
Public=󰀎:\
Templates=󱔗:\
Videos=󰕧:\
*.1=󰞋:\
*.7z=󰀼:\
*.7z=󰗄:\
*.a=󰌱:\
*.aac=󰈣:\
*.ace=󰗄:\
*.ai=󱇣:\
*.alz=󰗄:\
*.apk=󰀼:\
*.arc=󰗄:\
*.arj=󰗄:\
*.asf=󰈟:\
*.asm=󰌜:\
*.asp=󰖟:\
*.au=󰈟:\
*.aup=󰈣:\
*.avi=󰷝:\
*.bash=󰆍:\
*.bat=󰒓:\
*.bmp=󰈟:\
*.bz2=󰗄:\
*.bz=󰗄:\
*.c++=󰙲:\
*.c=󰙱:\
*.cab=󰗄:\
*.cbr=󱓷:\
*.cbz=󱓷:\
*.cc=󰙲:\
*.cgm=󰈟:\
*.class=󰬷:\
*.clj=󰈮:\
*.clj=󰈮:\
*.cljc=󰈮:\
*.cljs=󰈮:\
*.cmake=󰌱:\
*.cmd=󰆍:\
*.coffee=󰅶:\
*.conf=󰒓:\
*.cp=󰙲:\
*.cpio=󰀼:\
*.cpio=󰗄:\
*.cpp=󰙲:\
*.cs=󰌛:\
*.css=󰌜:\
*.cue=󰈣:\
*.cvs=󰒓:\
*.cxx=󰙲:\
*.d=󰈮:\
*.dart=󰈮:\
*.db=󰆼:\
*.deb=󰀼:\
*.diff=󰢪:\
*.dl=󰈟:\
*.dll=󰖳:\
*.doc=󰈬:\
*.docx=󰈬:\
*.dump=󰆼:\
*.dwm=󰗄:\
*.dz=󰗄:\
*.ear=󰗄:\
*.efi=󰈮:\
*.ejs=󰌝:\
*.elf=󰈮:\
*.emf=󰈟:\
*.epub=󰈬:\
*.erl=󰈮:\
*.esd=󰗄:\
*.exe=󰖳:\
*.f#=󰈮:\
*.fifo=󰟦:\
*.fish=󰈮:\
*.flac=󰈣:\
*.flc=󰈟:\
*.fli=󰈟:\
*.flv=󰷝:\
*.fs=󰈮:\
*.fs=󰈮:\
*.fsi=󰈮:\
*.fsscript=󰈮:\
*.fsx=󰈮:\
*.gem=󰀼:\
*.gif=󰈟:\
*.gitignore=󰊢:\
*.gl=󰈟:\
*.go=󰟓:\
*.gz=󰗄:\
*.gzip=󰗄:\
*.h=󰙱:\
*.hbs=󰈮:\
*.hh=󰙲:\
*.hpp=󰙲:\
*.hs=󰲒:\
*.htaccess=󰒓:\
*.htm=󰌝:\
*.html=󰌝:\
*.htpasswd=󰒓:\
*.ico=󰈟:\
*.img=󰗮:\
*.ini=󰒓:\
*.iso=󰗮:\
*.jar=󰬷:\
*.java=󰬷:\
*.java=󰬷:\
*.jl=󰌱:\
*.jpeg=󰈟:\
*.jpg=󰈟:\
*.js=󰌞:\
*.js=󰌞:\
*.json=󰘦:\
*.jsx=󱀤:\
*.key=󱕴:\
*.less=󰌜:\
*.lha=󰀼:\
*.lhs=󰲒:\
*.log=󰺄:\
*.lrz=󰗄:\
*.lua=󰢱:\
*.lz4=󰗄:\
*.lz=󰗄:\
*.lzh=󰗄:\
*.lzma=󰗄:\
*.lzo=󰗄:\
*.m2v=󰈟:\
*.m4a=󰈣:\
*.m4v=󰷝:\
*.markdown=󰍔:\
*.md=󰍔:\
*.mid=󰈣:\
*.midi=󰈣:\
*.mjpeg=󰈟:\
*.mjpg=󰈟:\
*.mka=󰈣:\
*.mkv=󰷝:\
*.ml=󰈮:\
*.mli=󰈮:\
*.mng=󰈟:\
*.mov=󰷝:\
*.mp3=󰈣:\
*.mp4=󰷝:\
*.mp4v=󰈣:\
*.mpc=󰈟:\
*.mpeg=󰷝:\
*.mpg=󰷝:\
*.msi=󰖳:\
*.mustache=󰈮:\
*.nix=󱄅:\
*.nuv=󰈟:\
*.o=󰌱:\
*.oga=󰈟:\
*.ogg=󰈣:\
*.ogm=󰈟:\
*.ogv=󰈟:\
*.ogx=󰈟:\
*.opus=󰈣:\
*.pbm=󰈟:\
*.pcx=󰈟:\
*.pdf=󰈥:\
*.pgm=󰈟:\
*.php=󰌟:\
*.php=󰌟:\
*.pl=󰈮:\
*.pl=󰈮:\
*.pm=󰈮:\
*.png=󰈟:\
*.ppm=󰈟:\
*.ppt=󰈟:\
*.pptx=󰈟:\
*.pro=󰏒:\
*.ps1=󰆍:\
*.psb=󱇣:\
*.psd=󱇣:\
*.pub=󱕴:\
*.py=󰌠:\
*.py=󰌠:\
*.pyc=󰌠:\
*.pyd=󰌠:\
*.pyo=󰌠:\
*.qt=󰈟:\
*.ra=󰈟:\
*.rar=󰀼:\
*.rar=󰗄:\
*.rb=󰴭:\
*.rb=󰴭:\
*.rc=󰒓:\
*.rlib=󱘗:\
*.rm=󰷝:\
*.rmvb=󰷝:\
*.rom=󰈮:\
*.rpm=󰀼:\
*.rpm=󰗄:\
*.rs=󱘗:\
*.rs=󱘗:\
*.rss=󰑫:\
*.rtf=󰈬:\
*.rz=󰗄:\
*.s=󰌜:\
*.sar=󰗄:\
*.scala=󰈮:\
*.scala=󰈮:\
*.scss=󰌜:\
*.sh=󰌜:\
*.sh=󰆍:\
*.slim=󰌝:\
*.sln=󰘐:\
*.so=󰌱:\
*.spx=󰈟:\
*.sql=󰆼:\
*.styl=󰌜:\
*.suo=󰘐:\
*.svg=󰈟:\
*.svgz=󰈟:\
*.swm=󰗄:\
*.t7z=󰗄:\
*.t=󰈮:\
*.tar=󰀼:\
*.tar=󰗄:\
*.taz=󰗄:\
*.tbz2=󰗄:\
*.tbz=󰗄:\
*.tga=󰈟:\
*.tgz=󰀼:\
*.tgz=󰗄:\
*.tif=󰈟:\
*.tiff=󰈟:\
*.tlz=󰗄:\
*.ts=󰛦:\
*.ts=󰛦:\
*.twig=󰌟:\
*.txz=󰗄:\
*.tz=󰗄:\
*.tzo=󰗄:\
*.tzst=󰗄:\
*.vim=󰒓:\
*.viminfo=󰒓:\
*.vimrc=󰒓:\
*.vob=󰈟:\
*.war=󰗄:\
*.wav=󰈣:\
*.webm=󰷝:\
*.wim=󰗄:\
*.wmv=󰷝:\
*.xbm=󰈟:\
*.xbps=󰀼:\
*.xcf=󰈟:\
*.xhtml=󰌝:\
*.xls=󰈛:\
*.xlsx=󰈛:\
*.xml=󰗀:\
*.xpm=󰈟:\
*.xspf=󰈟:\
*.xul=󰈹:\
*.xwd=󰈟:\
*.xz=󰀼:\
*.xz=󰗄:\
*.yaml=󰒓:\
*.yml=󰒓:\
*.yuv=󰈟:\
*.z=󰗄:\
*.zip=󰗄:\
*.zoo=󰗄:\
*.zsh=󰆍:\
*.zst=󰗄:\
di=󰉋:\
ex=󰑣:\
fi=󰎞:\
ln=󰌹:\
or=󰌺:\
tw=󰣞:\
ow=󰣞:\
st=󱂷:\
pi=󰟦:\
so=󰐧:\
bd=󰮆:\
cd=󰮆:\
su=󰴉:\
sg=󰴉:\
"
