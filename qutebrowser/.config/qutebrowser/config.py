import subprocess

from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
config: ConfigAPI = config
c: ConfigContainer = c


def read_xresources(prefix):
    props = {}
    x = subprocess.run(['xrdb', '-query'], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split('\n')
    for line in filter(lambda l: l.startswith(prefix), lines):
        prop, _, value = line.partition(':\t')
        props[prop] = value
    return props


xresources = read_xresources('*')
background = xresources['*background']
foreground = xresources['*foreground']
grey = xresources['*color8']

config.load_autoconfig(False)

c.content.proxy = 'socks5://localhost:1081'

c.tabs.padding = {'bottom': 8, 'left': 8, 'right': 8, 'top': 8}
c.tabs.indicator.padding = {'bottom': 2, 'left': 0, 'right': 4, 'top': 4}

c.zoom.default = '200%'

c.colors.tabs.bar.bg = background
c.colors.tabs.even.bg = background
c.colors.tabs.odd.bg = background
c.colors.tabs.selected.even.bg = grey
c.colors.tabs.selected.odd.bg = grey
c.colors.statusbar.normal.bg = background
c.statusbar.show = 'in-mode'
c.statusbar.position = 'bottom'
c.statusbar.widgets = ['url', 'history', 'scroll', 'progress']

c.fonts.default_size = '12pt'

c.editor.command = ['st', '-c', 'floating',
                    'vim', '{file}', '-c', 'normal {line}G{column0}l']

c.tabs.favicons.scale = 1.0
c.tabs.show = 'multiple'

c.window.title_format = '{perc}{current_title}{title_sep}qutebrowser'

c.content.autoplay = False

config.bind('<Alt-Left>', 'back')
config.bind('<Alt-Right>', 'forward')
config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Shift-Tab>', 'tab-prev')
config.bind('<Ctrl-r>', 'reload')
config.bind('<Ctrl-Shift-i>', 'devtools')
