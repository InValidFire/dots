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
    color_path = Path.home().joinpath("storage/config/prompt_color")
    if not color_path.exists():
        color_path.touch()
        color = 1
    else:
        color = int(color_path.read_text())
    if color > 8:
        color = 1
    color_path.write_text(str(random.randint(2, 8)))
    output = ""
    if bold:
        output = Style.BRIGHT
    output += colors[color] + text + Fore.RESET
    return output

