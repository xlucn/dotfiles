install:
	find * -type d -iregex "[a-z0-9]*/\..*" -printf "$$HOME/%P\n" | sort | uniq | xargs mkdir -pv
	find . -type d -iregex "\./[a-z0-9]*" -printf "%P\n" | xargs stow -t $$HOME -Sv

uninstall:
	find . -type d -iregex "\./[a-z0-9]*" -printf "%P\n" | xargs stow -t $$HOME -Dv
	find * -type d -iregex "[a-z0-9]*/\..*" -printf "$$HOME/%P\n" | sort -r | uniq | xargs -I {} find {} -maxdepth 0 -type d -empty -exec rm -dv {} \;

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
