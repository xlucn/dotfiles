import os
import visidata


CONFIG_HOME_DEFAULT = os.path.join(os.getenv("HOME"), ".config")
CONFIG_HOME = os.getenv("XDG_CONFIG_HOME", CONFIG_HOME_DEFAULT)

STATUS_BG = "cyan"
STATUS_FG = "black"
MENU_BG = "cyan"
MENU_FG = "black"
MENU_BG_ACTIVE = "white"

# use imported variable 'options' to make LSP happy
options = visidata.vd.options
options.visidata_dir = CONFIG_HOME
# status bar colors
options.color_active_status = f"{STATUS_FG} on {STATUS_BG}"  # active window status bar color
options.color_inactive_status = f"{STATUS_FG} on {STATUS_BG}"  # inactive window status bar color
options.color_status = f"{STATUS_FG} on {STATUS_BG}"  # status line color
options.color_keystrokes = f"{STATUS_FG} on {STATUS_BG}"  # color of input keystrokes on status line
options.color_warning = f"bold yellow on {STATUS_BG}"  # warning message color
options.color_error = f"bold red on {STATUS_BG}"  # error message color
options.color_top_status = ""
# menu colors
options.color_menu = f"{MENU_FG} on {MENU_BG}"  # color of menu items in general
options.color_menu_active = f"{MENU_FG} on {MENU_BG_ACTIVE}"  # color of active menu items
options.color_menu_help = f"{MENU_FG} italic on {MENU_BG}"  # color of helpbox
options.color_menu_spec = "black on green"  # color of sheet-specific menu items
# cell colors
options.color_column_sep = "white"  # color of column separators
options.color_default = "foreground on background"  # the default fg and bg colors
options.color_key_col = "bold blue"  # color of key columns
options.color_current_col = "bold"
# display
options.disp_int_fmt = "{:d}"  # default fmtstr to format for int values
options.disp_status_fmt = "{sheet.name} │ "  # status line prefix
options.disp_menu_push = "↥"  # indicator if command pushes sheet onto sheet stack
options.disp_menu_fmt = ""  # right-side menu format string
# histogram
options.histogram_bins = 20  # number of bins for histogram of numeric columns
options.numeric_binning = True  # bin numeric columns into ranges
