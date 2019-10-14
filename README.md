# dotfiles
Config files for everything

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/awesome.png?raw=true)

## Environment

- OS:
  - [Archlinux](http://www.archlinux.org/)
- WM:
  - [AwesomeWM](https://awesomewm.org/)
- Colorscheme:
  - [wal](https://github.com/dylanaraps/pywal)
  - [gruvbox](https://github.com/morhetz/gruvbox)
- Terminal Emulator
  - [urxvt](http://software.schmorp.de/pkg/rxvt-unicode.html)
- Text Editor
  - [vim](https://www.vim.org/)

## Requirement and recommendations

- fonts
  - [Hack](https://github.com/source-foundry/Hack)
  - [Terminus](https://github.com/powerline/fonts/tree/master/Terminus/PSF):
    for large font in linux console
  - [Nerd Font](https://nerdfonts.com):
    for awesome wm and fbterm

- curl for vim-plug auto install (in .vimrc) and a lot other scripts

- For [mutt](http://www.mutt.org/)/[neomutt](https://neomutt.org/):
  - [urlscan](https://github.com/firecat53/urlscan) for mutt url extracions
  - [pass](https://www.passwordstore.org/) for store email passwords
  - [gpg](https://gnupg.org/) for passwordstore and other encryptions

- For Awesome WM:
  - [lain](https://github.com/lcpz/lain) for wigdets library
  - [nemo](https://github.com/linuxmint/nemo) for file manager
  - [rofi](https://github.com/davatorium/rofi) for launcher
  - [compton](https://github.com/chjj/compton) for compositing
  - [xinput](https://www.x.org/archive/current/doc/man/man1/xinput.1.xhtml) for configuring trackpad.

## Install

Under every folder there are the files related to one program.
The files can be linked to corresponding places relative to home directory
with [stow](https://www.gnu.org/software/stow/)

```sh
stow <package name>
```

with `<package name>` being the folder name for a specific program except `system` which
should be installed in root.

There is no `-t` or `-v` arguments because I am using `.stowrc` file, but note that only
since version `2.3.1` can stow expand ~/$HOME in the rc file. If you are using stow
with older versions, you have to specify the target dir argument with `-t ~` in
the commands.

There are some system files in `system` folder need to deploy to `/`:

```sh
sudo stow -t / system
```

Or use the makefile:

```sh
make install
sudo make install-system
```

### Linux console setup

There is some programms that can work under linux console (tty) without X. After getting
familiar with those programms, you can become quite efficient working without a DE/WM.
And I configured a usable environment to make it more enjoyable.

To install configs specifically for them:

```sh
stow -v -t ~ fbterm tmux scripts
```

Those configs feature:

- Configs for `fbterm`, a more powerful (e.g. show utf-8 glyfs, faster) terminal emulator in framebuffer
- Tmux config specifically designed for using in fbterm
  - Try to mimic a tiling WM with multiple 'workspaces', e.g.
    - keep a specific layout,
    - start with multiple tmux windows,
    - not killing the last pane i.e. not closing any tmux window (so it's more like a workspace).
  - Keybindings are similar to AwesomeWM/dwm with `alt` being the mod key. A lot of operations
    are available with `alt + key` keybindings:
    - navigating between windows/panes,
    - moving panes between windows/panes,
    - resizing panes
    - creating and closing panes
    - launching programs
    - changing volume and even brightness (with `light`)
    - taking screenshot (with `fbgrab`, I prefer the executable from [fbcat](https://github.com/jwilk/fbcat) project)
    - start screensaver (with tty-clock)
  - CPU/memory/battery/volume/email/weather status indicator, and even more
  - Nerd font characters for window names and status inidicators. The choosed characters are fbterm-friendly
    and look terrible in other terminal emulators in DE/WM

Program recommendations (other than most well known like vim, ncmpcpp, tmux, etc.):
- framebuffer only
  - [fbcat](https://github.com/jwilk/fbcat) for taking screenshots
  - [fbv](https://github.com/godspeed1989/fbv) for wallpaper and image viewing
  - [jfbview](https://github.com/jichu4n/jfbview) recommended for viewing pdf/image
- graphical programs work both under X and framebuffer
  - [mpv](https://github.com/haikarainen/light) and [mplayer](mplayerhq.hu) for watching/streaming videos
    - `mpv --vo=drm`: more powerful
    - `mplayer -vo fbdev2`: can specify size and location in framebufffer
- terminal programs which naturally work everywhere
  - [light](https://github.com/haikarainen/light) for change screen brightness
  - [imagemagick](https://www.imagemagick.org/) for darkening the image as wallpaper
  - [tty-clock](https://github.com/xorg62/tty-clock) for lockscreen, only without locking
