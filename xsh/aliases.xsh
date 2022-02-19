source xsh/functions.xsh

def _debug():
	if $XONSH_SHOW_TRACEBACK:
		$XONSH_SHOW_TRACEBACK = False
		print("Debug mode disabled.")
	else:
		$XONSH_SHOW_TRACEBACK = True
		print("Debug mode enabled.")

def bw_get(object: str, bw_id: str, nulled: bool = False):
	if nulled and in_win():
		return !(bw get @(object) @(bw_id) a> nul)
	elif nulled and not in_win():
		return !(bw get @(object) @(bw_id) a> /dev/null)
	return $(bw get @(object) @(bw_id))

def _bwc(args: list):
	requires("bw")
	if not p'~/.bw_session'.exists():	
		raise FileNotFoundError("~/.bw_session")
	source ~/.bw_session

	if args[0] == "full":  # determine which keys to search for.
		items = ["username", "password", "totp"]
	elif args[0] == "password":
		items = ["password", "totp"]
	else:
		items = [args[0]]

	for i in items: # removes keys that don't exist for the object.
		if not bw_get(i, args[1], True):
			items.remove(i)
	
	print(f"found: {', '.join(items)}")
	for i in items:  # actually copy the info to clipboard.
		output = bw_get(i, args[1])
		to_clipboard(output)
		if items.index(i) < len(items) - 1:
			input(f"copied {i}, press enter to continue")
		else:
			print(f"copied {i}")

def _mcrcon(args: list):
	if p"~/.mcrcon".exists():
		source "~/.mcrcon"
	else:
		raise FileNotFoundError("~/.mcrcon")
	$(mcrcon @(" ".join(args)))

def _mcterm():
	if p"~/.mcrcon".exists():
		source "~/.mcrcon"
	else:
		raise FileNotFoundError("~/.mcrcon")
	mcrcon -t

def _alias():
	for alias in aliases:
		if callable(aliases[alias]):
			print(alias + " = ", aliases[alias].__name__)
		else:
			print(alias + " =", " ".join(aliases[alias]))

def _ensure_tmux(args: list):
	if $XONSH_SHOW_TRACEBACK:
		print(args)
	if not $(tmux has-session -t @(args[0])):
		tmux new-session -d -s @(args[0]) all> /dev/null
		$(tmux send-keys -t @(args[0]) @(f"cd {args[1]}") C-m)
		$(tmux send-keys -t @(args[0]) @(f"{args[2]}") C-m)

def _colortest():
	import sys
	for i in range(256):
		sys.stdout.write(f"\033[48;5;{i}m   ")
		if (i+1) % 16 == 0:
			sys.stdout.write("\033[0m\n")

def _ls():
     from colorama import Fore, Back, Style
     line_list = []
     command = $(cmd /c dir)
     for line in command.split("\n"):
         line = [x for x in line.split(" ") if x]
         if "<DIR>" in line:
             line[-1] = f"{Fore.GREEN}{line[-1]}{Style.RESET_ALL}"
         line = " ".join(line)
         line_list.append(line)
     [[print(x) for x in line_list]]

def load_aliases():
	aliases.update({
		'bwg': _bwc,
		'colortest': _colortest,
		'debug': _debug,
		'ls': 'ls -alhs --color=auto',
		'mc': _mcrcon,
		'mct': _mcterm,
		':q': 'exit',
		'ensure-tmux': _ensure_tmux,
		'aliases': _alias,
	})

	# WSL specific aliases
	if in_wsl():
		aliases.update({
			'wh': "cd /mnt/c/Users/Riley",
		})

	# Windows specific aliases
	if in_win():
		aliases.update({
			'config': 'git.exe --git-dir=$USERPROFILE/.cfg/ --work-tree=$USERPROFILE',
			'ls': ['cmd', '/c', 'dir'],  # get past namespace conflict with python's dir() function.
			'lsn': _ls,
			'lofi': ['powershell.exe', 'firefox.ps1', '-url', 'https://www.youtube.com/watch?v=5qap5aO4i9A/'],
		})

	if not in_win():
		aliases.update({
			'config': '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME',
		})
