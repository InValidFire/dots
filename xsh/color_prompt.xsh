source "~/xsh/keys.xsh"

def _color_prompt(text: str, bold: bool = False):
    colors = {
        2: "RED",
        3: "GREEN",
        4: "YELLOW",
        5: "BLUE",
        6: "PURPLE",
        7: "CYAN",
        8: "WHITE"
    }
    try:
        color = get_key("prompt_color")
        if color > 8:
            color = 2
    except ValueError:
        color = 2
    bold_str = ""
    if bold:
        bold_str = "BOLD_"
    output = f"{{{bold_str + colors[color]}}}{text}{{RESET}}"
    set_key("prompt_color", color+1)
    return output

def _reset_colors():
    return "{RESET}"
