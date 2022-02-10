from subprocess import run, PIPE

from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
config: ConfigAPI = config
c: ConfigContainer = c


def read_xresources(prefix):
    props = dict()
    res = run(['xrdb', '-query'], stdout=PIPE)
    for line in res.stdout.decode().split('\n'):
        if line.startswith(prefix):
            prop, _, value = line.partition(':')
            props[prop] = value.strip()
    return props


xresources = read_xresources('*')
background = xresources['*background']
foreground = xresources['*foreground']
grey = xresources['*color8']

xresources_xft = read_xresources("Xft")
xft_dpi = int(xresources_xft.get("Xft.dpi"))

config.load_autoconfig(False)

c.content.proxy = 'socks5://localhost:1081'
c.content.javascript.can_access_clipboard = True
c.content.blocking.enabled = True
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist-downloads.adblockplus.org/easylistchina.txt"
]

c.tabs.padding = {'bottom': 8, 'left': 8, 'right': 8, 'top': 8}
c.tabs.indicator.padding = {'bottom': 2, 'left': 0, 'right': 4, 'top': 4}

c.zoom.default = xft_dpi * 4 / 3

c.colors.tabs.bar.bg = background
c.colors.tabs.even.bg = background
c.colors.tabs.odd.bg = background
c.colors.tabs.selected.even.bg = grey
c.colors.tabs.selected.odd.bg = grey
c.colors.statusbar.normal.bg = background
c.colors.hints.bg = '#fff785'
c.statusbar.show = 'never'
c.statusbar.position = 'bottom'
c.statusbar.widgets = ['url', 'history', 'scroll', 'progress']

c.scrolling.smooth = True

c.fonts.default_size = '12pt'
c.fonts.hints = 'bold default_size monospace'

c.hints.radius = 4
c.hints.padding = {"bottom": 4, "left": 4, "right": 4, "top": 4}

c.editor.command = ['st', '-c', 'floating',
                    'vim', '{file}', '-c', 'normal {line}G{column0}l']

c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'b': 'https://www.bing.com/search?q={}',
    'g': 'https://www.google.com/search?q={}',
    'bd': 'https://www.baidu.com/s?wd={}',
    'gh': 'https://github.com/search?q={}',
    'gl': 'https://gitlab.com/search?search={}',
    'ap': 'https://archlinux.org/packages/?q={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
    'fd': 'https://search.f-droid.org/?q={}',
    'ads': 'https://ui.adsabs.harvard.edu/search/q={}',
    'aur': 'https://aur.archlinux.org/packages/?K={}',
    'rpg': 'https://repology.org/projects/?search={}',
}

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
config.bind('<,><p>', 'spawn --userscript password_fill')
config.bind('j', 'scroll-px 0 144')
config.bind('k', 'scroll-px 0 -144')
