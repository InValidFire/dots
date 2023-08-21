source "~/xsh/keys.xsh"

def _color_prompt(text: str, bold: bool = False):
    import random
    from colorama import Style, Fore
    from pathlib import Path
    colors = {
        2: Fore.RED,
        3: Fore.GREEN,
        4: Fore.YELLOW,
        5: Fore.BLUE,
        6: Fore.MAGENTA,
        7: Fore.CYAN,
        8: Fore.WHITE
    }
    try:
        color = get_key("prompt_color")
        if color > 8:
            color = 2
    except ValueError:
        color = 2
    output = ""
    if bold:
        output = Style.BRIGHT
    output += colors[color] + text + Fore.RESET
    set_key("prompt_color", color+1)
    return output

def _reset_colors():
    from colorama import Style, Fore
    return Style.RESET_ALL