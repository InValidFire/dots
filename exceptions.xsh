class CommandNotFoundException(Exception):
		def __init__(self, command):
			super().__init__(f"Command '{command}' not found.")