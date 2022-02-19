source xsh/exceptions.xsh

def in_wsl() -> bool:
	"""Determines if the system is running inside a WSL environment."""
	if in_win(): return False

	version = p'/proc/version'.read_text()
	if "microsoft" in version:
		return True
	return False

def in_win() -> bool:
	"""Determines if the system is running inside a Windows environment."""

	import os
	if 'OS' in os.environ and os.environ['OS'] == "Windows_NT":
		return True
	return False

def to_clipboard(text: str):
	"""Send text to the clipboard."""
	if in_wsl() or in_win():
		$(echo -n @(text) | clip.exe)
	else:
		requires("xclip")
		$(echo -n @(text) | xclip -sel clipboard)

def requires(command: str):
	"""Force exit the program if a required command is not found."""
	if not !(which @(command)):
		raise CommandNotFoundException(command) 
	return True

def append_path(path: str):
	"""Append a path to the end of the system's PATH variable."""
	import sys
	$PATH.extend([path])

	# enables us to import and use modules in the current working directory
	if sys.path[0] != '':
		sys.path.insert(0, '')
