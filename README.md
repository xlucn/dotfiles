# dotfiles
Config files for everything

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/dwm.png?raw=true)
*Screenshot: [my own fork](https://github.com/OliverLew/dwm) of dwm*
![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/awesomewm.png?raw=true)
*Screenshot: my customizations of awesomewm (not using/putting time into this for a long time)*

## Environment

- OS: [Archlinux](http://www.archlinux.org/)
- WM: [dwm](https://dwm.suckless.org/) ([my fork](https://github.com/OliverLew/dwm) with a lot of patches)
- Terminal Emulator: [st](https://st.suckless.org/) ([my fork](https://github.com/OliverLew/st) with mainly scrollback and xresources patches)
- Network Manager: systemd-networkd + systemd-resolved + iwd
- Brightness control: [brightnessctl](https://github.com/Hummer12007/brightnessctl)
- Music player: [mpd](https://github.com/MusicPlayerDaemon/MPD/) + [mpc](https://github.com/MusicPlayerDaemon/mpc) + [ncmpc](https://github.com/MusicPlayerDaemon/ncmpc)
- Text editor: [vim](https://github.com/vim/vim)

## Requirement and recommendations

- fonts
  - [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) for terminal
  - [Terminus](https://github.com/powerline/fonts/tree/master/Terminus/PSF) for tty
  - [Material Design Icons font](https://github.com/templarian/MaterialDesign/) for status bar
- curl for network operations in a lot of scripts
- [urlscan](https://github.com/firecat53/urlscan) for mutt url extractions
- [pass](https://www.passwordstore.org/) for storing passwords (e.g. for emails)
- [rofi](https://github.com/davatorium/rofi) and [dmenu](https://tools.suckless.org/dmenu/) for launcher
- [picom](https://github.com/yshui/picom) (a fork of [compton](https://github.com/chjj/compton))/[xcompmgr](https://gitlab.freedesktop.org/xorg/app/xcompmgr) for compositing

## Install

Under every folder there are the files related to one program.
The files are organized in the same structure as they are relative to user's home directory
and can be deployed with [stow](https://www.gnu.org/software/stow/)

```sh
stow <package name>
```

with `<package name>` being the folder name for a specific program (except `system` which
should be installed in root with `-t /` option).
There is no `-t` or `-v` arguments because I am using `.stowrc` file.

## Linux console setup

![test](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/fbterm.png?raw=true)
*Screenshot: Playing video with `mplayer` while running `tmux` in `fbterm`*

There is some programs that can work under linux console (tty) without X. After getting
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

### Program recommendations (other than most well known like vim, ncmpcpp, tmux, etc.):
- framebuffer only
  - [fbcat](https://github.com/jwilk/fbcat) for taking screenshots
  - [fbv](https://github.com/godspeed1989/fbv) for wallpaper and image viewing
  - [jfbview](https://github.com/jichu4n/jfbview) recommended for viewing pdf/image
- graphical programs work both under X and framebuffer
  - [mpv](https://github.com/haikarainen/light) and [mplayer](mplayerhq.hu) for watching/streaming videos
    - `mpv --vo=drm`: more powerful
    - `mplayer -vo fbdev2`: can specify size and location in framebufffer
- terminal programs which naturally work everywhere
  - [imagemagick](https://www.imagemagick.org/) for darkening the image as wallpaper
  - [tty-clock](https://github.com/xorg62/tty-clock) for lock screen, only without locking
