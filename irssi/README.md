# Irssi configuration files

- [irssi](.local/bin/irssi)

  Wrapping script runs irssi in a tmux session to work with some irssi
  scripts, e.g., `adv_windowlist.pl` or `tmux-nicklist-portable.pl`.

  - Detach with ctrl+\ (same as abduco)

- [pass_identify.pl](.config/irssi/scripts/autorun/pass_identify.pl)

  Avoid hard coded passwords in irssi config. Perl script `pass_identify.pl`
  will automatically run `msg nickserv identify password` for you. The
  passwords will be extracted with `pass` command.

- [autorun.pl](.config/irssi/scripts/autorun/autorun.pl)

  A perl script to load other scripts. The idea is to use a text file
  to configure autorun, instead of previously with symlinks. It works
  well if you install the [irssi-scripts][AUR] package in Arch Linux,
  this way you don't have to manage (download/copy) the script files
  by yourself.

  [AUR]: https://aur.archlinux.org/packages/irssi-scripts-git
