# dotfiles
config files

## Environment
- OS: [Archlinux][]
- DE: [Gnome3][]
- gnome-terminal/termite
- vim8 (asynchronous tasks support)

## Requirement

### fonts

vim-airline: [Hack][] (Hack font has better patched powerline glyphs)

### Vundle 

To install Vundle

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Linters for ALE (optional)

ALE is a Asynchronous Lint Engine that can work on neovim or vim8.

linters:
- C: cppcheck, gcc
- Python: pylint, autopep8
- JSON: jq, prettier

## Problem solving configurations

- Fugitive sign column update is slow, in vimrc
```vim
set updatetime=100
```
- Delay when escaping out of insert mode, in vimrc
```vim
set ttimeoutlen=0
```
and in tmux.conf(if using it)
```tmux
set -g escape-time 0
```
- Leader guide plugin takes a second to pop up, in vimrc
```vim
set timeoutlen=300
```
this makes the list pop up in 0.3 seconds.

##
[Archlinux]: https://www.archlinux.org
[Gnome3]: https://www.gnome.org
[Hack]: https://github.com/source-foundry/Hack

