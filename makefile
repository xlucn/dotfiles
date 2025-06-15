# repo: https://github.com/OliverLew/dotfiles.git
# makefile to deploy dotfiles (and system files)

# in case the make targets conflicts with real files
.PHONY: dotfiles dotfiles-uninstall system system-uninstall

# install any dotfiles into home folder
dotfiles:
	find -- * -type d -iregex "[a-z0-9]*/\..*" -printf "$$HOME/%P\n" | sort | uniq \
		| xargs mkdir -pv
	find -- * -type d -iregex "[a-z0-9]*/\..*" -printf "%H\n" | sort | uniq \
		| xargs stow -t $$HOME -Sv

dotfiles-uninstall:
	find -- * -type d -iregex "[a-z0-9]*/\..*" -printf "%H\n" | sort | uniq \
		| xargs stow -t $$HOME -Dv
	find -- * -type d -iregex "[a-z0-9]*/\..*" -printf "$$HOME/%P\n" | sort -r | uniq \
		| xargs -I {} find {} -maxdepth 0 -type d -empty -exec rm -dv {} \;

# install any non-dot files except readme into system folder
system:
	find . -type f -iregex "\./[a-z0-9]*/[^.].*" -not -iname readme.md -printf "%P\n" \
		| { while read -r f; do diff -qN "$$f" "/$${f#*/}" || install -Dv "$$f" "/$${f#*/}"; done; }

system-uninstall:
	find . -type f -iregex "\./[a-z0-9]*/[^.].*" -not -iname readme.md -printf "%P\n" \
		| { while read -r f; do rm -v "/$${f#*/}"; done; }
