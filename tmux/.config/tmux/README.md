In the `.tmux.conf.fbterm` are the **fancy** setup of tmux to mimic a tiling window manager (mainly dwm).

- Try to mimic a tiling WM with multiple 'workspaces', e.g.
  - keep a specific layout,
  - start with multiple tmux windows,
  - not killing any existing windows.
- Keybindings are similar to AwesomeWM/dwm with `alt` being the mod key. A lot of operations are available including:
  - `Alt + [1-9]/,/./j/k`: navigating between windows/panes
  - `Alt + [!-(]/</>/J/K`: moving panes to new windows/panes
  - `Alt + h/l/H/L`: resizing panes horizontally and vertically
  - `Alt + Enter/q`: creating and closing panes
  - `Alt + [/]/\/-/=`: changing volume and brightness (with `light`)
  - `Alt + {/}/|/_/+`: control mpd (seek forward/backward, pause, previous and next)
  - `Alt + Ctrl + L`: start screensaver (with tty-clock)
  - taking screenshot in framebuffer (with `fbgrab`, I prefer the executable from [fbcat](https://github.com/jwilk/fbcat) project)
- CPU/memory/battery/volume/email/weather status indicator, and even more.
  Note: need the scripts in `../scripts` folder
- The configuration uses nerd font characters for window names and status indicators.
  The chosen characters are fbterm-friendly (because fbterm can't show all the double-width characters in nerd fonts perfectly, yet, and the mono space nerd font looks small and terrible)
