# Irssi configuration files

Wrapping script around irssi featuring:

- Run irssi in a tmux session to work with some irssi scripts, e.g.
  `adv_windowlist.pl` or `tmux-nicklist-portable.pl`
- Export irc passwords with `pass` through shell environments so that they
  can be used in irssi config (so no hard coded credentials in irssi config)
- Detach with ctrl+\ (same as abduco)
- Should take any irssi argument as if you are using /usr/bin/irssi
  However they won't work if you are attaching a existing session

Requirements (optional):

- Install 'pass' if you want to use exported passwords
- Install 'tmux' if you want to use detachable sessions and windowlist or
  nicklist scripts

Note:

1. The passwords stored with 'pass' store should be under a 'irc' subfolder
   and have the file structure as (actually it does not matter):
   ```
   irc
   └── network
       └── nickname/key/etc
   ```
   You can create it with
   ```sh
   pass insert irc/network/nickname
   ```
   The exported shell variable are named as `$pass_network_nickname`.
   Use the variables in irssi config like
   ```conf
   autosendcmd = "/^msg nickserv identify ${pass_network_nickname}";
   ```

2. The script even starts tmux inside another tmux session.
   The side effect is tried to be minimized by unbinding all tmux keybindings
   and hiding the status bar in the nested session so that the outer tmux
   works like the nested session never exists.
   P.S. Tmux can still be controlled by `/exec tmux` command inside irssi.
