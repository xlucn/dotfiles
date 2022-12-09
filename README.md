# dotfiles

Config files for everything.

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/dwm.png?raw=true)

## Environment

- OS: [Archlinux][] for most recent versions of programs.
- WM: [dwm][] ([my fork][dwm_fork]).
- Terminal Emulator: [st][] ([my fork][st_fork]).
- Network: systemd-networkd + iwd.
- Music player: [mpd][] + [mpc][] + [ncmpc][]
- Text editor: [neovim][]

[Archlinux]: https://www.archlinux.org/
[dwm]: https://dwm.suckless.org/
[dwm_fork]: https://github.com/oliverlew/dwm
[st]: https://st.suckless.org/
[st_fork]: https://github.com/oliverlew/st
[mpd]: https://github.com/MusicPlayerDaemon/MPD/
[mpc]: https://github.com/MusicPlayerDaemon/mpc
[ncmpc]: https://github.com/MusicPlayerDaemon/ncmpc
[neovim]: https://github.com/neovim/neovim

## Manage dotfiles

I manage my configuration files with [stow][] and a simple makefile. Every
top-level folder is treated as a stow "package". Stow will link the files
inside those folders to user's home directory. For example, `package/.foo/bar`
will be linked to `$HOME/.foo/bar`.

[stow]: https://www.gnu.org/software/stow/

There are two kinds of files:

- Dotfiles: files like `package/.foo/bar`

  These files go to the user's home directory. Managed by **stow**. Install with

```sh
make dotfiles  # deploy "dot" files
```

- System files: files like `package/foo/bar`

  These files go to root directory. The reason for this is some system files
  doesn't work if they are symlinks, so they will be copied to the target
  directly. Install with

```sh
make system    # deploy system files
```

## Topics

There are some interesting configuration files that I think deserve sharing.
Follow the link to read more.

### [Bash](bash)

- My own shell prompt script, simple and fast.
- Readline configuration, making bash a powerful interactive shell.
- Environment variables, with lots of XDG path settings.

### [Fbterm](fbterm)

Fbterm is a terminal emulator under linux console. It can show Unicode
characters, more colors. Combined with tmux, it can create a quite powerful
GUI-free environment.

### [MPD](mpd/.config)

MPD is a music player daemon. I mostly use ncmpc as the front end.

### [Mutt](neomutt)

Mutt is a TUI mail client.

Apart from normal configurations, I created a `mutt_bootstrap` script
to support multiple accounts by listing and selecting an email address
from `pass` password store, and extracting the password therein.

### [Python](python/.config)

IPython has plenty customization options, such as vi keybinding mode.

Ptpython is a enhanced REPL environment, such as showing function signature and
docstring

### [Rofi](rofi/.config/rofi)

There is a GNOME-style launcher theme.

### [Scripts](scripts/.local/bin)

A lot of scripts.

### [Tmux](tmux/.config/tmux)

As a heavy tmux user, I mapped most actions to `Alt-KEY`, similar to WM
keybindings. I think this style can improve efficiency by quite a lot, because
you don't have to press a chain of key combination (e.g., `Alt-Enter` replaces
`Ctrl-A` then `minus`)

### [(Neo)Vim](vim/.config)

- Neovim. I am gradually de-coupling neovim from vim configurations. More specifically, I am adding more lua plugins to replace vim script ones.
- Vim. I am doing my best to make the configuration fast and lightweight.
- Ex/Vi. Try this old text editor, you will learn vi(m) faster.

### [Miscellaneous](config)

All other configuration files. Some interesting ones I like:
- Gnu `info` [keybings](config/.config/infokey) for vim users. Now you know more than pressing q to quit!
- `Top` [settings](config/.config/procps) to make it as eye-candy as possible.
