"""
Storage Module:

Classes:
- Storage
"""
from __future__ import annotations

import json
import shutil

from pathlib import Path

__all__ = ['Storage']

class Storage:
    """
    Unifies all filesystem access methods under a single class.
    Minimizes room for mistakes and improves reusability.

    Methods:
    - get_file()
    - get_folder()
    - write_file()
    - read_file()
    - delete_file()
    - rename_file()
    - add_file()
    - list_files()
    """

    def __init__(self, folder: str, root_folder: str = ".storage") -> None:
        """
        Create a new storage instance, it automatically creates and manages a folder in the user's home directory, all you have to do is supply a subfolder to store files in.

        Args:
            folder (str): the name of the folder to use.
        """
        self.root = Path.home().joinpath(root_folder)
        self.folder = self.root.joinpath(folder)
        self.folder.mkdir(exist_ok=True, parents=True)

    def get_file(self, path: str) -> Path:
        """Get the fully qualified path of a file in the folder.

        Args:
            path (str): the name of the file to grab.

        Returns:
            Path: the path of the file.
        """
        return self.folder.joinpath(path)

    def get_folder(self, name: str) -> Storage:
        """
        Get a folder inside the Storage directory.
        Returns a Storage object representing that folder.
        """
        return Storage(name, root_folder=self.folder.name)

    def write_file(self, name: str, data: dict):
        """Write data to the given file in JSON format.

        Args:
            name (str): the name of the file.
            data (dict): the data to write.
        """
        file = self.get_file(name)
        file.touch(exist_ok=True)
        with file.open("w+", encoding="utf-8") as f:
            json.dump(data, f, indent=4)

    def read_file(self, name: str) -> dict:
        """Read data from the given file in JSON format.

        Args:
            name (str): the name of the file.

        Returns:
            dict: the data from the file.
        """
        file = self.get_file(name)
        if not file.exists():
            return {}
        with file.open("r+", encoding="utf-8") as f:
            data = json.load(f)
        return data

    def delete_file(self, name: str):
        """Delete the given file from the folder.

        Args:
            name (str): the name of the file.
        """
        file = self.get_file(name)
        file.unlink(missing_ok=True)

    def rename_file(self, old_name: str, new_name: str):
        """Rename a file in the folder.

        Args:
            old_name (str): the current name of the file.
            new_name (str): the new name of the file.
        """
        file = self.get_file(old_name)
        new_file = self.folder.joinpath(new_name)
        file.rename(new_file)

    def add_file(self, name: str,  path: Path | None = None, binary: bytes | None = None):
        """Add a copy of a file to the folder.
        If a binary stream is given, it is saved directly to the named location.

        Args:
            name (str): The name to save it under.
            path (Path): The path of the file to copy from.
            binary (BinaryIO): The binary stream to copy from.
        """
        if path is not None and binary is not None:
            raise ValueError(binary, "Cannot supply both a path and a binary stream.")
        elif path is not None:
            shutil.copy(path, self.folder.joinpath(name))
        elif binary is not None:
            with self.folder.joinpath(name).open("wb+") as f:
                f.write(binary)

    def list_files(self, pattern: str | None = None) -> list[Path]:
        """
        Return a list of all files in the directory.
        """
        files: list[Path] = []
        if pattern is None:
            for file in self.folder.iterdir():
                files.append(file)
        else:
            for file in self.folder.glob(pattern):
                files.append(file)
        return files
