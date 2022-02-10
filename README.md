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

### [Bash](bash)

- Shell prompt script. From my experience, those common bash prompts
  are sometimes too slow. So I wrote one myself, featuring basic user
  and host information, current directory, ssh indicator, file manager
  (lf and ranger) level, job counts, git status and so on.
- Readline configuration, or inputrc. Readline makes bash a powerful
  interactive shell, but the configuration needs some work.
- Environment variables in `.profile`. Lots of them are for XDG path
  specification, preventing some programs dump files directly in home.

### [MPD](mpd)

MPD is a music player daemon. You start it in background and control
with other clients. I mostly use ncmpc as the front end. It's not as
powerful as ncmpcpp, but enough for me.

### [Mutt](neomutt)

Mutt is a TUI mail client. All things including colors, formats and
keybindings can be customized.

I use mutt currently, since it's enough for me, and without so many
dependencies. Most configurations are in `muttrc`, `neomuttrc` sources
the formal one and adds neomutt specific settings.

Apart from that, I created a `mutt_bootstrap` python script to support
multiple accounts by listing and selecting an email address with `fzf`,
and some private setup such as email addresses and passwords, with the
help of `pass` command. This way, the information are stored securely
in a password store, instead of as plain text in muttrc.

### [Scripts](scripts)

A lot of scripts either works in status bars, or on their own such as
print all 256 colors, print glyphs in a font, configure monitors, etc.
For details, open the folder and see the readme therein.
## Manage dotfiles

I manage my configuration files with [stow](https://www.gnu.org/software/stow/)
and a simple makefile.

There are two kinds of files here:
  - "Dotfiles" that go into home directory.
  - Files that are in the system root folders.

Each kind of the files is treated separately. The reason is
that some system files doesn't work if they are symlinks, which are exactly what `stow`
creates. So those in home directory are managed with `stow`, those in root with makefile.

### What does `stow` do:

Every folder is treated as a stow "package". Under every folder there are the "dot"
files related to one program or one topic. The files in the folders are organized
as they are relative to home directory, e.g. `package/.config/file` becomes
`$HOME/.config/file`. The "dotfiles" can be deployed with
```sh
stow -t $HOME -v <package name>
```

I have a `.stowrc` to ensure even without arguments, the files are stowed to $HOME,
and all README files are ignored.

### Use the makefile

I keep all the configuration files in my home directory in/as a "dot" folder/file.
The makefile will treat all files or folders starting with `.` as "dotfiles".
Deploy all dotfile packages with:
```sh
make dotfiles
```

All the system files should not start with a dot. For example, `package/etc/file`
becomes `/etc/file`. Deploy those files with
```sh
make system
```

