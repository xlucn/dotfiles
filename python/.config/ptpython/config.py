from ptpython.layout import CompletionVisualisation

__all__ = ['configure']


def configure(repl):
    # Input
    repl.vi_mode = True
    repl.confirm_exit = False
    # Vim-like text selecting
    repl.enable_mouse_support = True
    repl.enable_auto_suggest = True
    # When using ptipython, use IPython's visual mode
    repl.enable_open_in_editor = False

    # Display
    # Pop-up will show completion type (e.g., function, keyword)
    repl.completion_visualisation = CompletionVisualisation.POP_UP
    repl.prompt_style = 'ipython'
    # Function argument hint in pop-up
    repl.show_signature = True
    # Function document in a bottom pane
    repl.show_docstring = True
    repl.show_status_bar = False
    repl.highlight_matching_parenthesis = True

    # Colors
    # use terminal's 16 basic colors
    repl.use_code_colorscheme("native")
    repl.color_depth = "DEPTH_4_BIT"
