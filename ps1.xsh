from xonsh.built_ins import XSH

@XSH.builtins.events.on_transform_command
def ps1_preproc(cmd, **kw):
	if cmd.split(" ")[0].strip().endswith(".ps1"):
		cmd = f"powershell.exe {cmd}"
	return cmd