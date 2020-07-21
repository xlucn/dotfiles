# dotfiles
Config files for everything

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/dwm.png?raw=true)
![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/awesomewm.png?raw=true)

## Environment

- OS:
  - [Archlinux](http://www.archlinux.org/)
- WM:
  - [dwm](https://dwm.suckless.org/) ([my fork](https://github.com/OliverLew/dwm) with a lot of patches)
  - [AwesomeWM](https://awesomewm.org/)
- Terminal Emulator
  - [st](https://st.suckless.org/) ([my fork](https://github.com/OliverLew/st) with mainly scrollback and xresources patches)
- Color scheme:
  - material color scheme

## Requirement and recommendations

- fonts
  - [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) and [Hack](https://github.com/source-foundry/Hack) for code
  - [Terminus](https://github.com/powerline/fonts/tree/master/Terminus/PSF) and [Unifont](http://unifoundry.com/unifont/index.html) for Unicode bitmap font (in tty)
  - [Material Design Icons font](https://github.com/templarian/MaterialDesign/) and [Nerd Font](https://nerdfonts.com) for status bar

- curl for vim-plug auto install (in .vimrc) and a lot other scripts

- For [mutt](http://www.mutt.org/)/[neomutt](https://neomutt.org/):
  - [urlscan](https://github.com/firecat53/urlscan) for mutt url extractions
  - [pass](https://www.passwordstore.org/) for store email passwords
  - [gpg](https://gnupg.org/) for password-store and other encryptions

- For Awesome WM:
  - [rofi](https://github.com/davatorium/rofi) for launcher
  - [picom](https://github.com/yshui/picom) for compositing (a fork of [compton](https://github.com/chjj/compton))

## Install

Under every folder there are the files related to one program.
The files are organized in the same structure as they are relative to user's home directory
and can be deployed with [stow](https://www.gnu.org/software/stow/)

```sh
stow <package name>
```

with `<package name>` being the folder name for a specific program (except `system` which
should be installed in root with `-t /` option).

There is no `-t` or `-v` arguments because I am using `.stowrc` file, but note that only
since version `2.3.0` can stow expand ~/$HOME in the rc file. If you are using stow
with older versions, you have to specify the target dir argument with `-t ~` in
the commands.

Another way is to use the makefile:

```sh
make install
sudo make install-system
```

### Linux console setup

![](https://github.com/OliverLew/oliverlew.github.io/blob/pictures/fbterm.png?raw=true)

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

#### Program recommendations (other than most well known like vim, ncmpcpp, tmux, etc.):
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
  - [tty-clock](https://github.com/xorg62/tty-clock) for lock screen, only without locking
