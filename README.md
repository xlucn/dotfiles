# dotfiles

Config files for everything. See the [topics](#topics) section for details and follow the links therein.

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/dwm.png?raw=true)

## Environment

- OS: [Archlinux](http://www.archlinux.org/) for most recent versions of programs.
- WM: [dwm](https://dwm.suckless.org/) ([my fork](https://github.com/OliverLew/dwm)).
- Terminal Emulator: [st](https://st.suckless.org/) ([my fork](https://github.com/OliverLew/st)).
- Network: systemd-networkd + iwd.
- Brightness control: [brightnessctl](https://github.com/Hummer12007/brightnessctl)
- Music player: [mpd](https://github.com/MusicPlayerDaemon/MPD/) + [mpc](https://github.com/MusicPlayerDaemon/mpc) + [ncmpc](https://github.com/MusicPlayerDaemon/ncmpc)
- Text editor: [vim](https://github.com/vim/vim)

## Topics

Follow the link to read more.

### [Bash](bash)

- Shell prompt script. It's simple and fast.
- Readline configuration, making bash a powerful interactive shell.
- Environment variables, with lots of XDG path settings.

### [MPD](mpd)

MPD is a music player daemon. I mostly use ncmpc as the front end.

### [Mutt](neomutt)

Mutt is a TUI mail client.

Apart from normal configurations, I created a `mutt_bootstrap` script
to support multiple accounts by listing and selecting an email address
from `pass` password store, and extracting the password therein.

### [Scripts](scripts)

A lot of scripts.

### [Miscellaneous](config)

All other configuration files. Some interesting ones I like:
- Gnu `info` [keybings](config/.config/infokey) for vim users. Now you know more than pressing q to quit!
- `Top` [settings](config/.config/procps) to make it as eye-candy as possible.
- `Ex`/`Vi` [configuration](config/.config/ex/exrc). Try this old text editor, you will learn vi(m) faster.

## Manage dotfiles

I manage my configuration files with [stow](https://www.gnu.org/software/stow/)
and a simple makefile.

There are two kinds of files here:

- "Dotfiles" that go into home directory. Managed by **stow**:

  Every folder is treated as a stow "package". Under every folder, there
  are the "dot" files, which are organized as they are relative to home
  directory. Deployed with `stow -t $HOME -v <package name>`.

- Files that are in the system root folders.

  Some system files doesn't work if they are symlinks, so they will be
  copied to the target directly. They *shouldn't* start with "dot".


Use the makefile:

```sh
make dotfiles  # deploy "dot" files
make system    # deploy system files
```
