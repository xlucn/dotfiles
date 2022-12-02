from ptpython.layout import CompletionVisualisation

__all__ = ['configure']


def configure(repl):
    # Input
    repl.vi_mode = True
    repl.confirm_exit = False
    repl.enable_mouse_support = True
    repl.enable_auto_suggest = True
    # Display
    repl.completion_visualisation = CompletionVisualisation.POP_UP
    repl.prompt_style = 'ipython'
    repl.show_signature = True
    repl.show_docstring = True
    repl.show_status_bar = True
    repl.highlight_matching_parenthesis = True
    # Colors
    repl.use_code_colorscheme("native")
    repl.color_depth = "DEPTH_4_BIT"
