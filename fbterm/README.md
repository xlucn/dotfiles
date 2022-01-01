# Linux console setup

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

## Program recommendations (other than most TUI programs):

- framebuffer only
  - [fbcat](https://github.com/jwilk/fbcat) for taking screenshots
  - [fbv](https://github.com/godspeed1989/fbv) for wallpaper and image viewing
  - [jfbview](https://github.com/jichu4n/jfbview) recommended for viewing pdf/image
- graphical programs work both under X and framebuffer
  - [mpv](https://github.com/haikarainen/light) and [mplayer](mplayerhq.hu) for watching/streaming videos
    - `mpv --vo=drm`: more powerful
    - `mplayer -vo fbdev2`: can specify size and location
