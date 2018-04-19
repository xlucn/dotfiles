# dotfiles
config files

## Environment
- OS: [Archlinux][]
- DE: [Gnome3][]

for vim:
- gnome-terminal/termite

  (found termite works better with powerline glyphs)

- vim8

## Requirement

### fonts

For vim-airline:

- [Hack][]

  (Hack font has better patched powerline glyphs)


### Vundle

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### For ALE (optional)

ALE is a Asynchronous Lint Engine that can work on neovim or vim8.

linters:
- C
  - cppcheck
  - gcc
- Python
  - pylint
  - autopep8
- JSON
  - jq
  - prettier

###
[Archlinux]: https://www.archlinux.org
[Gnome3]: https://www.gnome.org
[Hack]: https://github.com/source-foundry/Hack

