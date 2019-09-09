# dotfiles
Config files for everything

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/awesome.png?raw=true)

## Environment

- OS:
  - [Archlinux](http://www.archlinux.org/)
- WM:
  - [AwesomeWM](https://awesomewm.org/)
- Colorscheme:
  - [gruvbox](https://github.com/morhetz/gruvbox)
    everywhere: awesome, terminal, vim, rofi, zathura(pdf)
- Terminal Emulator
  - [termite](https://github.com/thestinger/termite)
  - urxvt
- Text Editor
  - [vim](https://www.vim.org/)

## Requirement

- fonts
  - [Hack](https://github.com/source-foundry/Hack)(recommend only)
  - [Terminus](https://github.com/powerline/fonts/tree/master/Terminus/PSF):
    for linux console
  - [Nerd Font](https://nerdfonts.com):
    for awesome wm and tmux

- curl for vim-plug auto install (in .vimrc)

- For [mutt](http://www.mutt.org/)/[neomutt](https://neomutt.org/):
  - [urlscan](https://github.com/firecat53/urlscan) for mutt url extracions
  - [pass](https://www.passwordstore.org/) for store email passwords
  - gpg for passwordstore and other encryptions

- For Awesome WM:
  - [lain](https://github.com/lcpz/lain) for wigdets library
  - [thunar](https://wiki.archlinux.org/index.php/Thunar)/nemo for lightweight file manager and volume manager
  - [rofi](https://github.com/davatorium/rofi) for launcher
  - [compton](https://github.com/chjj/compton) for compositing
  - [xinput](https://www.x.org/archive/current/doc/man/man1/xinput.1.xhtml) for configuring trackpad.

- For fbterm+tmux:
  - fbv for wallpaper and image viewing
  - jfbview recommended for viewing pdf/image
  - imagemagick for darkening the image as wallpaper

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
sudo stow -v -t / <package name>
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
- Tmux config specifically designed(font/char choice, keybinding, etc.) for using in fbterm
- External image/video viewer in elinks

## Problem solving configurations

- Fugitive sign column update is slow, in .vimrc

  ```vim
  set updatetime=100
  ```

- Delay when escaping out of insert mode, in .vimrc

  ```vim
  set ttimeoutlen=0
  ```

  and in tmux.conf(if using it)

  ```tmux
  set -g escape-time 0
  ```
- Leader guide plugin takes a second to pop up, in .vimrc

  ```vim
  set timeoutlen=300
  ```

  this makes the list pop up in 0.3 seconds.

- Programs not showing correctly in tmux (tremc in my case), in .tmux.conf

  Refer to the NOTE on [tmux github wiki FAQ page](https://github.com/tmux/tmux/wiki/FAQ)

  The TERM environment varialbe must be "tmux", "screen" or similar.

