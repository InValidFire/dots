source ~/xsh/functions.xsh

def bw_get(object: str, bw_id: str, captured: bool = False):
	if captured and in_win():
		return !(bw get @(object) @(bw_id) a> nul)
	elif captured and not in_win():
		return !(bw get @(object) @(bw_id) a> /dev/null)
	return $(bw get @(object) @(bw_id) err>out)

def handle_mac(mac_message: str):
    print("Authentication has expired, please log out with `bw logout` and log back in with `bw login`")

def handle_duplicates(duplicate_message: str, args: list):
    if "More than one result was found." in bw_get("username", args[1]):
        import json
        duplicate_ids = duplicate_message.split("\n")[1:]
        names = []
        for duplicate_id in duplicate_ids:
            item = json.loads(bw_get("item", duplicate_id))
            names.append(item["name"])
        print("There were duplicates found:")
        for i, name in enumerate(names):
            print(f"{i}. {name}")
        choice = int(input("Which would you like to get? "))
        return duplicate_ids[choice]

def load_bw_session():
    from pathlib import Path
    session_file = Path.home().joinpath("storage/config/bw_session")
    $(source @(session_file))

def handle_items(args: list) -> list:
    """Checks if the possible items exist for the requested ID. If they do not, they get removed."""
    if args[0] in ["full", "f"]:
        items = ['username', 'password', 'totp']
    elif args[0] in ["password", "p", "pass"]:
        items = ['password', 'totp']
    else:
        items = [args[0]]

    # can I speed this up somehow?
    duplicate_test = bw_get(items[0], args[1])  # has to happen here before items are filtered out. otherwise the error message will cause problems.
    if "More than one result was found." in duplicate_test:
        args[1] = handle_duplicates(duplicate_test, args)

    for i in items:
        if not bw_get(i, args[1], True):
            items.remove(i)
    return items

def get_output_from_items(items: list, args: list):
    output = {}
    for i in items:  # store values in dict
        output[i] = bw_get(i, args[1])
    return output

def bw_main(args: list):
    requires("bw")
    print("Loading...")
    load_bw_session()
    items = handle_items(args)
    print("Getting items...")
    output = get_output_from_items(items, args)
    print(f"found: {', '.join(items)}")
    for key in output:  # copy dict values to clipboard
        to_clipboard(output[key])
        input(f"copied {key}, press enter to continue")
