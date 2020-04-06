In the `tmux.conf.fbterm` are the **fancy** setup of tmux to mimic a tiling window manager (mainly dwm).

**Note:** I use a lot of new features from latest versions of tmux, e.g. keybinding notes, new hooks, etc., so is something does not work for you, try the latest [git version](https://github.com/tmux/tmux).

- Try to mimic a tiling WM with multiple 'workspaces', e.g.
  - keep a specific (stack by default) layout,
  - start with multiple tmux windows,
  - not killing any existing windows.
- Keybindings are similar to AwesomeWM/dwm with `alt` being the mod key. A lot of operations are available including:
  - `alt + [1-9,.]`: navigating between windows/panes
  - `alt + Shift + [1-9,.]`: moving panes to other windows/panes
  - `alt + h/l/H/L`: resizing master and slave panes
  - `alt + Enter/q`: creating and closing panes
  - `alt + [ ] \ - =`: volume down, up, toggle, brightness down and up
  - `alt + { } | _ +`: MPD forward, backward, pause, previous and next
  - `alt + ctrl + L`: start screen-saver (with the help of `tty-clock`)
  - taking screenshot in framebuffer (with `fbgrab`, I prefer the executable from [fbcat](https://github.com/jwilk/fbcat) project)
- CPU/memory/battery/volume/email/weather status indicator, and even more.
  Note: need the scripts in [scripts](../../scripts) folder
- The configuration uses nerd font characters for window names and status indicators.
  The chosen characters are fbterm-friendly (because fbterm can't show all the double-width characters in nerd fonts perfectly, yet, and the mono space nerd font looks small and terrible)
