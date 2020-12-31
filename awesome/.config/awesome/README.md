# AwesomeWM configuration files

## Features

### Material design layout

This is similar to [material-awesome](https://github.com/PapyElGringo/material-awesome) and
[Glorious-Dotfiles](https://github.com/manilarome/Glorious-Dotfiles):

- Top bar: task-list (icon + close button), new-term button, a few indicators, layout box
- Left bar: launcher, tag-list, systray, date-time
- Left panel: resource monitor, control widgets, MPD client

### Some details

1. Full-screen response: hide the bars and panels only for full-screen and focused program.
This fixes some cases not covered by material-awesome and Glorious-Dotfiles. For details,
see the function `fullscreen_toggle` and signals that calls it.

2. Start different email accounts in `(neo)mutt`. This could be done if there is a separate
configuration file `~/.config/(neo)mutt/<email_address>.muttrc` for each email address which can load
the corresponding email. For exactly how to add multiple accounts support in `(neo)mutt`, see
[this gist](https://gist.github.com/9456162.git)

## Structure

There is only 4 files (plus some shell scripts in the same repo):

- [`config.lua`](config.lua): some customizable variables.
- [`rc.lua`](rc.lua): keybindings, rules, signals and all the other things that should be done in a WM.
- [`theme.lua`](theme.lua): colors, fonts, sizes, icons.
- [`widgets.lua`](widgets.lua): everything you see on the bars / panels.

## Requirements

- Some shell scripts in the `scripts` folder of this repo
- `curl`: all kinds of network related tasks (e.g. email)
- `brightnessctl`: brightness control
- `amixer`: volume control
- `rofi`: app launcher, command prompts

Optional:

- NetworkManager: network name and wifi signal strength
- mpd: music player daemon
- mpc, ncmpcpp: mpd clients
- (neo)mutt: email client

## Install

1. Put all the lua scripts here in `$HOME/.config/awesome`.
2. Put the relevant shell scripts in any folder in $PATH
