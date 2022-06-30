"""Integrates Johnny Decimal Notation into Xonsh"""
from pathlib import Path

from xonsh.built_ins import XSH

HOME = Path("/run/media/riley/drive")

def find_category(number: int, path, regex: str):
	"""Find matching JDN folder when given notation"""
	import re
	folders = path.iterdir()
	for folder in folders:
		if not folder.is_dir():
			continue
		folder_category = re.match(regex, folder.name)
		if folder_category is None:
			continue
		if len(folder_category.groups()) == 2:
			if number >= int(folder_category.group(1)) and number <= int(folder_category.group(2)):
				return folder
		elif len(folder_category.groups()) == 1:
			if number == int(folder_category.group((1))):
				return folder
	return path

@XSH.builtins.events.on_transform_command
def jds_preproc(cmd: str, **kw):
	"""processes command strings starting with "`" to cd to matching folder."""
	if cmd.startswith("`") and "." in cmd and not cmd.strip().endswith("`"):
		try:
			johnny_decimal_notation = cmd.replace("`", "")
			bucket = find_category(int(johnny_decimal_notation.split(".")[0]), HOME, r"(^\d0)-(\d9)")
			category = find_category(int(johnny_decimal_notation.split(".")[0]), bucket, r"^(\d\d)")
			folder = find_category(int(johnny_decimal_notation.split(".")[1]), category, r"^(\d\d)")
			cmd = f"cd '{folder.resolve()}'"
		except FileNotFoundError:
			cmd = f'print("\'{HOME}\' not found.")'
		except ValueError:
			cmd = f'print("\'{cmd.strip().replace("`", "")}\' is not a valid JDN.")'
	elif cmd.startswith("`") and not cmd.strip().endswith("`"):
		try:
			johnny_decimal_notation = cmd.replace("`", "")
			if johnny_decimal_notation == "\n":
				return f"cd '{HOME.resolve()}'"
			bucket = find_category(int(johnny_decimal_notation.split(".")[0]), HOME, r"(^\d0)-(\d9)")
			category = find_category(int(johnny_decimal_notation.split(".")[0]), bucket, r"^(\d\d)")
			cmd = f"cd '{category.resolve()}'"
		except FileNotFoundError:
			cmd = f'print("\'{HOME}\' not found.")'
		except ValueError:
			cmd = f'print("\'{cmd.strip().replace("`", "")}\' is not a valid JDN.")'
	return cmd
