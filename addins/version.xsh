import platform
from pathlib import Path

__all__ = ['Version']

class Platform:
	def __init__(self):
		self.architecture = platform.architecture()
		self.machine = platform.machine()
		self.node = platform.node()
		self.platform = platform.platform()
		self.processor = platform.processor()
		self.release = platform.release()
		self.system = platform.system()
		self.version = platform.version()

class Version:
	def __init__(self):
		data = self._load_dict()
		for key, value in data.items():
			setattr(self, key.lower(), value)
		if hasattr(self, "id_like"):  # special handling for ID_LIKE
			self.id_like = self.id_like.split()
		if not hasattr(self, "platform"):
			self.platform = Platform()

	def _load_dict(self):
		data = {}
		os_files = Path('/etc').glob("*-release")
		for i in os_files:
			with i.open() as f:
				for line in f:
					line = line.split("=")
					data[line[0]] = line[1].strip().replace('"', '')
		return data
