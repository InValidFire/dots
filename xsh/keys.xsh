def verify_file():
    from pathlib import Path
    path = Path.home().joinpath("storage/config.json")
    if not path.exists():
        path.parent.mkdir(exist_ok=True, parents=True)
        path.touch()
        path.write_text("{}")

def get_key(key: str):
    import json
    from pathlib import Path
    path = Path.home().joinpath("storage/config.json")
    with path.open(mode="r", encoding="utf-8") as fp:
        data = json.load(fp)
    if key in data.keys():
        return f"success: {data[key]}"
    else:
        return "error: no value"

def write_key(key: str, value: str):
    import json
    from pathlib import Path
    path = Path.home().joinpath("storage/config.json")
    with path.open(mode="r", encoding="utf-8") as fp:
        data = json.load(fp)
    data[key] = value
    with path.open(mode="w", encoding="utf-8") as fp:
        json.dump(data, fp)
    return f"success: {data[key]}"

def delete_key(key: str):
    import json
    from pathlib import Path
    path = Path.home().joinpath("storage/config.json")
    with path.open(mode="r", encoding="utf-8") as fp:
        data = json.load(fp)
    data.pop(key)
    with path.open(mode="w", encoding="utf-8") as fp:
        json.dump(data, fp)
    return f"success: {data}"

def config_main(args: list):
    import argparse
    parser = argparse.ArgumentParser(prog="config editor",
                                     description="edit the config values for the dotfiles")
    parser.add_argument('mode', type=str, help="read, write, or delete")
    parser.add_argument('key', type=str, help="the key in the config to access")
    parser.add_argument('value', type=str, nargs='?', help="the value to write, only needed in write mode")

    args = parser.parse_args(args)

    verify_file()
    
    if args.mode.lower() == 'read':
        print(get_key(args.key))
    elif args.mode.lower() == 'write':
        print(write_key(args.key, args.value))
    elif args.mode.lower() == 'delete':
        print(delete_key(args.key))
    else:
        print("Unexpected value for: mode")
    