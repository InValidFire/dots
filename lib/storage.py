"""
Storage Module:

Classes:
- Storage (Legacy)
- StorageRoot
- StorageFolder
- StorageFile
"""
from __future__ import annotations

import json
from pathlib import Path

__all__ = ['StorageRoot', 'StorageFile', 'StorageFolder']

class StorageFolder:
    def __init__(self, path: Path, root: StorageRoot) -> None:
        self.path = path
        self.root = root
        if not self.path.exists():
            raise FileNotFoundError(self.path)

    @property
    def parent(self) -> StorageFolder | None:
        if self.root.path not in self.path.parents and self.root.path.parent != self.path:
            return None
        return StorageFolder(self.path.parent, self.root)

    def get_folder(self, name: str) -> StorageFolder:
        path = self.path.joinpath(name)
        if path.exists():
            return StorageFolder(path, self.root)
        raise FileNotFoundError

    def get_folders(self) -> list[StorageFolder]:
        folders = []
        for folder in self.path.iterdir():
            if not folder.is_dir():
                continue
            folders.append(StorageFolder(folder, self.root))
        return folders

    def get_files(self, pattern: str | None = None) -> list[StorageFile]:
        files: list[StorageFile] = []
        if pattern is None:
            for file in self.path.iterdir():
                if not file.is_file():
                    continue
                files.append(StorageFile(file, self))
        else:
            for file in self.path.glob(pattern):
                if not file.is_file():
                    continue
                files.append(StorageFile(file, StorageFolder(file.parent, self.root)))
        return files

    def __str__(self) -> str:
        return str(self.path)

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}("{self.path}")'

class StorageFile:
    def __init__(self, path: Path, parent: StorageFolder) -> None:
        self.parent = parent
        self.path = path

    def delete(self):
        self.path.unlink()

    def rename(self, new_name: str | Path):
        self.path.rename(new_name)

    def read(self) -> dict:
        if not self.path.exists():
            return {}
        with self.path.open("r+", encoding="utf-8") as f:
            data = json.load(f)
        return data

    def write(self, data: dict | bytes) -> None:
        self.path.touch(exist_ok=True)
        if isinstance(data, dict):
            with self.path.open("w+", encoding="utf-8") as f:
                json.dump(data, f, indent=4)
        elif isinstance(data, bytes):
            self.path.write_bytes(data)

    def __str__(self) -> str:
        return str(self.path)

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}("{self.path}")'

class StorageRoot(StorageFolder):
    def __init__(self, path: Path = Path.home().joinpath(".storage")) -> None:
        super().__init__(path, self)

    @property
    def path(self):
        """The root folder, all Folder objects should be a child of this."""
        return self._path

    @path.setter
    def path(self, new_path: str | Path):
        if isinstance(new_path, str):
            self._path = Path.home().joinpath(new_path)
        elif isinstance(new_path, Path):
            self._path = new_path
        else:
            raise TypeError(new_path)