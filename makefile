install:
	stow -t ~ -v `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

uninstall:
	stow -t ~ -v -D `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

install-system:
	stow -t / -v system

uninstall-system:
	stow -t / -v -D system
