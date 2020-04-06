# Scripts

There are some scripts that can be used in shell or spawned automatically in some WM indicator widgets.

Interesting tools

- **`cmplayer`**: play video inside tmux panes with `mplayer` in framebuffer(tty)
- **`lschars`**: print code points and characters from a font in a nice format
- **`setmonitor`**: `rofi`/`dmenu` script for managing monitors

Other tools

- `jcount`: count how many systemd journal logs belongs to each program (in base you want to know which program is generating the most logs)
- `pdfgrep`: grep for pdf files
- `psg`: grep for `ps` command / enhanced `pgrep`
- `sdu`: enhanced `du`, only the first level and sort by size (human readable)
- `openurl`: scan for urls in piped texts and open them in dmenu
- `color256test`: print all 256 colors
- `colortermtest`: print all color/style combinations with shell escape sequence (`\e[$i;${fg};${bg}m`)

Some system info scripts

- `ac`: ac charging status
- `battery`: battery level
- `cpu`: cpu usage (better if periodically executed)
- `imap`: email unread count
- `mem`: various memory info (single number)
- `network`: network name/speed for specified/found interface
- `vol`: volume status and level
- `up`: system up time

Tmux helper scripts

- `imap-tmux`: show multiple imap accounts
- `wttr`/`wttr-tmux`: show weather
