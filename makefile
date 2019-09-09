install:
	stow -t ~ -v `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

uninstall:
	stow -t ~ -v -D `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

NOXLIST=aria2 bash elinks fbterm git gnupg irssi mpd mpv mutt redshift scripts tmux transmission tremc vcsi vifm vim

XAPPLIST=awesome compton feh gtk libinput-gestures mediainfo pdfpc rofi sxiv termite X x11vnc zathura

install-nox:
	stow -t ~ -v ${NOXLIST}

uninstall-nox:
	stow -t ~ -v -D ${NOXLIST}

install-x:
	stow -t ~ -v ${XAPPLIST}

uninstall-x:
	stow -t ~ -v -D ${XAPPLIST}

install-system:
	sudo stow -t / -v system

uninstall-system:
	sudo stow -t / -v -D system
