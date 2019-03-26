# dotfiles
config files

## Environment

- OS:
  - [Archlinux](http://www.archlinux.org/)
- DE:
  - [Gnome3](https://www.gnome.org)
  - [AwesomeWM](https://awesomewm.org/)
- Software
  - gnome-terminal/termite/rxvt-unicode
  - vim8 (asynchronous tasks support)

## Requirement

- fonts
  - [Hack](https://github.com/source-foundry/Hack):
    for vim-airline (Hack font has better patched powerline glyphs)
  - [powerline-console-fonts](https://github.com/powerline/fonts/tree/master/Terminus/PSF):
    for linux console
  - [Nerd Font](https://nerdfonts.com):
    for awesome wm tags

- Powerline
  - [Powerline](https://github.com/powerline/powerline)
    for tmux status line and shell prompt

- Linters for ALE (optional)
  ALE is a Asynchronous Lint Engine that can work on neovim or vim8.

  - C: cppcheck, gcc
  - Python: pylint, autopep8
  - JSON: jq, prettier

- curl for vim-plug auto install (in .vimrc)

- For Awesome WM:
  - xinput for configuring trackpad.

## Install

The files can be linked to corresponding places with `stow`

```sh
stow -v -t ~ <package name>
```

with `<package name>` being the folder name for a specific program.

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

## Thanks/References

https://dougblack.io/words/a-good-vimrc.html

https://github.com/wklken/vim-for-server

https://github.com/r00k/dotfiles
