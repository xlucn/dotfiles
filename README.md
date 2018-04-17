# dotfiles
config files

## Environment
- OS: [Archlinux][]
- DE: [Gnome3][]

for vim:
- gnome-terminal
- vim8

## Requirement

### fonts

For vim-airline:

- Hack / Adobe Source Code Pro (these works better with powerline fonts and I like them)
- powerline fonts

### Vundle

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

TODO: can I do this with github submodule?

[Archlinux]: www.archlinux.org
[Gnome3]: www.gnome.org

### ALE

ALE is a Asynchronous Lint Engine that can work on neovim or vim8.

linters:
- C
  - cppcheck
  - gcc
- Python
  - pylint
  - autopep8
