# dotfiles

Config files for everything

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/dwm.png?raw=true)
*Screenshot: [my own fork](https://github.com/OliverLew/dwm) of dwm*

## Manage dotfiles with `make` and `stow`

I manage my configuration files with [stow](https://www.gnu.org/software/stow/)
and a simple makefile.

Files that go into home directory and system root are treated separately. The reason is
that some system files doesn't work if they are symlinks, which are exactly what `stow`
creates. So those in home directory are managed with `stow`, those in root with makefile.

### What does `stow` do:

Every folder is treated as a stow "package". Under every folder there are the "dot"
files related to one program or one topic. The "dot" files are organized in the same
structure as they are relative to user's home directory, which can be deployed with
```sh
stow -t $HOME -v <package name>
```

### "Dot" files in user home directory

I keep all the configuration files in my home directory in/as a "dot" folder/file.
That is, the relative path to `$HOME` must start with `.`, e.g.
`package/.config/file` will go to `$HOME/.config/file`,
`package/.configfile` will go to `$HOME/.configfile`.

With the makefile, deploy all dotfile packages with:
```sh
make dotfiles
```

### System files in root directory

All the system files should not start with a dot.
For example, `package/etc/file` will go to `/etc/file`.

Deploy those files with
```sh
make system
```

## Environment

- OS: [Archlinux](http://www.archlinux.org/)
- WM: [dwm](https://dwm.suckless.org/) ([my fork](https://github.com/OliverLew/dwm) with a lot of patches)
- Terminal Emulator: [st](https://st.suckless.org/) ([my fork](https://github.com/OliverLew/st) with mainly scrollback and xresources patches)
- Network Manager: systemd-networkd + systemd-resolved + iwd
- Brightness control: [brightnessctl](https://github.com/Hummer12007/brightnessctl)
- Music player: [mpd](https://github.com/MusicPlayerDaemon/MPD/) + [mpc](https://github.com/MusicPlayerDaemon/mpc) + [ncmpc](https://github.com/MusicPlayerDaemon/ncmpc)
- Text editor: [vim](https://github.com/vim/vim)

## Linux console setup

![test](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/fbterm.png?raw=true)
*Screenshot: Playing video with `mplayer` while running `tmux` in `fbterm`*

There are some programs that can work under linux console (tty) without GUI. After getting
familiar with those programs, you can become quite efficient working without a DE/WM.
And I configured a usable environment to make it more enjoyable with the help of tmux and
fbterm.

To install configs specifically for them:

```sh
stow fbterm tmux scripts
```

Those configs feature:

- Configs for `fbterm`, a more powerful (e.g. show utf-8 glyphs, faster) terminal emulator in framebuffer
- Tmux config specifically designed for using in fbterm, for details see [the readme](tmux/) in tmux folder.

### Program recommendations (other than most TUI programs):
- framebuffer only
  - [fbcat](https://github.com/jwilk/fbcat) for taking screenshots
  - [fbv](https://github.com/godspeed1989/fbv) for wallpaper and image viewing
  - [jfbview](https://github.com/jichu4n/jfbview) recommended for viewing pdf/image
- graphical programs work both under X and framebuffer
  - [mpv](https://github.com/haikarainen/light) and [mplayer](mplayerhq.hu) for watching/streaming videos
    - `mpv --vo=drm`: more powerful
    - `mplayer -vo fbdev2`: can specify size and location
