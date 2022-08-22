"""Integrates Johnny Decimal Notation into Xonsh"""
from pathlib import Path

from xonsh.built_ins import XSH
from lib import JDS

HOME = Path("/run/media/riley/drive")

@XSH.builtins.events.on_transform_command
def jds_preproc(cmd: str, **kw):
	"""processes command strings starting with "`" to cd to matching folder."""
	if cmd.startswith("`") and "." in cmd and not cmd.strip().endswith("`"):
		try:
			johnny_decimal_notation = cmd.replace("`", "").strip()
			path = JDS(HOME).get_item(johnny_decimal_notation).path
			cmd = f'cd "{path.resolve()}"'
		except FileNotFoundError:
			cmd = f'print("\'{HOME}\' not found.")'
		except ValueError:
			cmd = f'print("\'{cmd.strip().replace("`", "")}\' is not a valid JDN.")'
	elif cmd.startswith("`") and not (len(cmd.strip()) >= 2 and cmd.strip().endswith("`")):
		try:
			johnny_decimal_notation = cmd.replace("`", "").strip()
			if johnny_decimal_notation == "":
				return f"cd '{HOME.resolve()}'"
			category = JDS(HOME).get_category(johnny_decimal_notation).path
			cmd = f"cd '{category.resolve()}'"
		except FileNotFoundError as exc:
			cmd = f'print("errored:", exc)'
		except ValueError:
			cmd = f'print("\'{cmd.strip().replace("`", "")}\' is not a valid JDN.")'
	return cmd.strip()
