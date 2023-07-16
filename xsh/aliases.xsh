source ~/xsh/functions.xsh
source ~/xsh/bw.xsh
source ~/xsh/backup.xsh
source ~/xsh/roku.xsh
source ~/xsh/keys.xsh

def _debug():
	if $XONSH_SHOW_TRACEBACK:
		$XONSH_SHOW_TRACEBACK = False
		print("Debug mode disabled.")
	else:
		$XONSH_SHOW_TRACEBACK = True
		print("Debug mode enabled.")

def _mcrcon(args: list):
	try:
		storage = lib.StorageRoot()
		servers_data = storage.get_file(".mcrcon.json").read()
		server_data = servers_data[args[0]]
		$MCRCON_HOST = server_data["address"]
		$MCRCON_PORT = server_data["port"]
		$MCRCON_PASS = server_data["password"]
		$(mcrcon @(" ".join(args[1:])))
	except IndexError:
		print("Please indicate which server to connect to.")
	except KeyError:
		print("Server configuration not found.")
	except FileNotFoundError:
		print("Server configuration file '.mcrcon.json' is not found.")

def _mcterm(args: list):
	try:
		storage = lib.StorageRoot()
		servers_data = storage.get_file(".mcrcon.json").read()
		server_data = servers_data[args[0]]
		$MCRCON_HOST = server_data["address"]
		$MCRCON_PORT = server_data["port"]
		$MCRCON_PASS = server_data["password"]
		mcrcon -t
	except IndexError:
		print("Please indicate which server to connect to.")
	except KeyError:
		print("Server configuration not found.")
	except FileNotFoundError:
		print("Server configuration file '.mcrcon.json' is not found.")

def _mclist():
	try:
		storage = lib.StorageRoot()
		server_data = storage.get_file(".mcrcon.json").read()
		print("Servers:")
		for key in servers_data:
			print("\t-", key)
	except FileNotFoundError:
		print("Server configuration file '.mcrcon.json' is not found.")

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

def _bwc(args: list):
	try:
		bw_main(args)
	except KeyboardInterrupt:
		print("\nAborting!")
		return

def _ytv(args: list):
	roku_main(args)

def _backup(args: list):
	backup_main(args)

def _config(args: list):
	config_main(args)

def _restore(args: list):
	restore_main(args)

def load_aliases():
	aliases.update({
		'backup': _backup,
		'restore': _restore,
		'key': _config,
		'bwg': _bwc,
		'colortest': _colortest,
		'debug': _debug,
		'ls': 'ls -alhs --color=auto',
		'mc': _mcrcon,
		'mct': _mcterm,
		'mcl': _mclist,
		':q': 'exit',
		'ensure-tmux': _ensure_tmux,
		'ytv': _ytv
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
