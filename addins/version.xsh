from pathlib import Path

__all__ = ['Version']

class Version:
    def __init__(self):
        data = self._load_dict()
        for key, value in data.items():
            setattr(self, key.lower(), value)
        if hasattr(self, "id_like"):  # special handling for ID_LIKE
            self.id_like = self.id_like.split()

    def _load_dict(self):
        data = {}
        os_files = Path('/etc').glob("*-release")
        for i in os_files:
            with i.open() as f:
                for line in f:
                    line = line.split("=")
                    data[line[0]] = line[1].strip().replace('"', '')
        return data
