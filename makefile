install:
	find . -type d | grep -v "\.\/\(\.git\|system\)" | sed -n 's/\.\/[a-zA-Z]*\/\(.*\)/\1/p' | sort | uniq | while read -r dir; do mkdir -p "$$HOME/$$dir"; done
	stow -t ~ -v `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

uninstall:
	stow -t ~ -v -D `ls --ignore=.git* --ignore=system --ignore=README.md --ignore=.stowrc --ignore=makefile`

install-system:
	for i in $$(find system/); do \
		if [ -d $$i ]; then mkdir -p $${i#system}; fi; \
		if [ -h $${i#system} ]; then \
			echo "file $$i is a symbolic link"; \
			exit; \
		fi; \
		if [ -f $$i ] && ! { [ -f $${i#system} ] && diff $$i $${i#system} > /dev/null; }; then \
			cp -v $$i $${i#system}; \
		fi; \
	done

uninstall-system:
	for i in $$(find system/ | sed '1!G;h;$$!d'); do \
		[ -d $$i ] && [ -z "$$(ls -A $${i#system})" ] && rmdir $${i#system}; \
		[ -h $${i#system} ] && echo "file $$i is a symbolic link" && exit; \
		[ -f $$i ] && [ -f $${i#system} ] && diff $$i $${i#system} > /dev/null && \
			rm -v $${i#system}; \
	done
