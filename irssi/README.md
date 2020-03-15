# Irssi configuration files

Wrapping script around irssi featuring:

- Run irssi in a tmux session to work with some irssi scripts, e.g.
  `adv_windowlist.pl` or `tmux-nicklist-portable.pl`
- Export irc passwords with [`pass`](passwordstore.org/) through shell environments so that they
  can be used in irssi config (so no hard coded passwords in irssi config)
- Detach with ctrl+\ (same as abduco)
- You should be able to use the `irssi` script with any arguments that
  `/usr/bin/irssi` accept with no problem.
  However they won't work if you are attaching a existing session

### Requirements (optional):

- [`pass`](passwordstore.org/) for exporting passwords
- `tmux` for detachable sessions and windowlist/nicklist scripts

### Note:

1. The passwords stored with 'pass' should be under a 'irc' subfolder
   and has two more levels (recommend them to be network name and nick/etc),
   e.g. you can create one password for a nick in some network with
   ```sh
   pass insert irc/network/nickname
   ```
   The exported shell variable are named as `$pass_network_nickname`.
   Use the variables in irssi config like
   ```conf
   autosendcmd = "/^msg nickserv identify ${pass_network_nickname}";
   ```

2. The script even starts tmux inside another tmux session.
   The inner tmux session is almost undetectable since all tmux keybindings
   are unbound and the status bar is hidden so that the outer tmux session
   works like the nested session never exists.

   P.S. Tmux can still be controlled by `/exec tmux` command inside irssi.
