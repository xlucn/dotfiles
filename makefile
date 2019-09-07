install:
	stow -t ~ -v `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

install-system:
	sudo stow -t / -v system

uninstall:
	stow -t ~ -v -D `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

uninstall-system:
	sudo stow -t / -v -D system
