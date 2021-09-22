from .version import Version
v = Version()

class Package:
	def __init__(self, name, source):
		self.name = name
		self.source = source
		self._installed = None

	@property
	def installed(self):
		self._installed = self._get_installed()
		return self._installed

	def _get_installed(self) -> bool:
		if self.source == 'apt':
			if !(dpkg -s @(self.name)).returncode == 0:
				return True
			else:
				return False
		if self.source == 'npm':
			if !(npm list -g @(self.name)).returncode == 0:
				return True
			else:
				return False
		else:
			return None

	def install(self):
		if self.installed:	
			print(f"package '{self.name}' already installed.")
			return
		elif self.source == 'apt':
			$(sudo apt-get install -qq --yes @(self.name))
		elif self.source == 'npm':
			$(npm install -g @(self.name))
		elif self.source == 'pacman':
			$(pacman -Syu @(self.name))
		else:
			print(f"unsupported package manager '{source}'.")
