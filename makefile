install:
	find . -type d | grep -v "\.\/\(\.git\|system\)" | sed -n 's/\.\/[a-zA-Z]*\/\(.*\)/\1/p' | sort | uniq | while read -r dir; do mkdir -p "$$HOME/$$dir"; done
	stow -t ~ -v `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

uninstall:
	stow -t ~ -v -D `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

install-system:
	for i in $$(find system/); do \
		[ -d $$i ] && mkdir -p $${i#system}; \
		[ -h $${i#system} ] && echo "file $$i is a symbolic link" && exit; \
		[ -f $$i ] && ! { [ -f $${i#system} ] && diff $$i $${i#system} > /dev/null; } && \
			cp -v $$i $${i#system}; \
	done

uninstall-system:
	for i in $$(find system/ | sed '1!G;h;$$!d'); do \
		[ -d $$i ] && [ -z "$$(ls -A $${i#system})" ] && rmdir $${i#system}; \
		[ -h $${i#system} ] && echo "file $$i is a symbolic link" && exit; \
		[ -f $$i ] && [ -f $${i#system} ] && diff $$i $${i#system} > /dev/null && \
			rm -v $${i#system}; \
	done
