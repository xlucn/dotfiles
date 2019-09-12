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
    everywhere: awesome, terminal, vim, rofi, zathura(pdf)
- Terminal Emulator
  - [termite](https://github.com/thestinger/termite)
  - [urxvt](http://software.schmorp.de/pkg/rxvt-unicode.html)
- Text Editor
  - [vim](https://www.vim.org/)

## Requirement and recommendations

- fonts
  - [Hack](https://github.com/source-foundry/Hack)
  - [Terminus](https://github.com/powerline/fonts/tree/master/Terminus/PSF):
    for linux console
  - [Nerd Font](https://nerdfonts.com):
    for awesome wm and tmux

- curl for vim-plug auto install (in .vimrc) and a lot other scripts

- For [mutt](http://www.mutt.org/)/[neomutt](https://neomutt.org/):
  - [urlscan](https://github.com/firecat53/urlscan) for mutt url extracions
  - [pass](https://www.passwordstore.org/) for store email passwords
  - gpg for passwordstore and other encryptions

- For Awesome WM:
  - [lain](https://github.com/lcpz/lain) for wigdets library
  - nemo for file manager
  - [rofi](https://github.com/davatorium/rofi) for launcher
  - [compton](https://github.com/chjj/compton) for compositing
  - [xinput](https://www.x.org/archive/current/doc/man/man1/xinput.1.xhtml) for configuring trackpad.

- For fbterm+tmux session (all are optional but every useful):
  - [fbv](https://github.com/godspeed1989/fbv) for wallpaper and image viewing
  - [jfbview](https://github.com/jichu4n/jfbview) recommended for viewing pdf/image
  - [fbcat](https://github.com/jwilk/fbcat) for screenshot
  - imagemagick for darkening the image as wallpaper
  - [tty-clock](https://github.com/xorg62/tty-clock) for lockscreen, only without locking

## Install

Under every folder there are the files related to one program.
The files can be linked to corresponding places relative to home directory
with [stow](https://www.gnu.org/software/stow/)

```sh
stow -v -t ~ <package name>
```

with `<package name>` being the folder name for a specific program. There are
some system files in `system` folder need to deploy to `/`:

```sh
sudo stow -v -t / system
```

Or use the makefile:

```sh
make install
sudo make install-system
```

### Linux console setup

There is some programms that can work under linux console(tty). To install configs
specifically for them(not including basic ones like bash):

```sh
stow -v -t ~ elinks fbterm scripts tmux
```

Those configs include

- Configs for a more powerful(e.g. utf-8 glyfs) terminal emulator, fbterm
- Tmux config specifically designed for using in fbterm (font/char choice, keybinding, etc.)
- External image/video viewing with jfbview/mpv in elinks
