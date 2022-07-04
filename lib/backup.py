"""
Backup Module:

Classes:
- BackupManager
"""
from datetime import datetime
from pathlib import Path
from zipfile import ZipFile

from . import Storage

__all__ = ["BackupManager"]

class BackupManager:
    """
    Facilitates backup creation. Stores all backups in ~/.storage/backups

    Methods:
    - create_backup()
    - get_backups()
    - get_delete_candidates()
    - delete_excess_backups()
    """
    def __init__(self, target_path: Path, backup_storage: Storage = Storage("backups"),
                 date_format: str = "%d_%m_%y__%H%M%S", separator: str = "-") -> None:
        """
        Test
        """
        self.target_path = target_path
        self.backup_storage = backup_storage
        self.date_format = date_format
        self.separator = separator

    @property
    def target_path(self) -> Path:
        """
        Target to create backups of. This could be a file or folder.
        """
        return self._target_path

    @target_path.setter
    def target_path(self, new_path: Path):
        if isinstance(new_path, Path):
            if new_path.exists() and (new_path.is_dir() or new_path.is_file()):
                self._target_path = new_path
            else:
                raise ValueError(new_path)
        else:
            raise TypeError(new_path)

    @property
    def backup_storage(self) -> Storage:
        """
        Storage object to store created backups in.
        """
        return self._backup_storage

    @backup_storage.setter
    def backup_storage(self, new_storage: Storage):
        if isinstance(new_storage, Storage):
            self._backup_storage = new_storage
        else:
            raise TypeError(new_storage)

    @property
    def date_format(self) -> str:
        """The datetime format string used to date the backups."""
        return self._date_format

    @date_format.setter
    def date_format(self, new_format):
        if isinstance(new_format, str):
            self._date_format = new_format
        else:
            raise TypeError(new_format)

    @property
    def separator(self) -> str:
        """The separator that separates the archive name from the date"""
        return self._separator

    @separator.setter
    def separator(self, new_separator):
        if isinstance(new_separator, str):
            if new_separator not in self.target_path.name and new_separator not in self.date_format:
                self._separator = new_separator
            else:
                raise ValueError(new_separator)
        else:
            raise TypeError(new_separator)

    def create_backup(self):
        """
        Create a backup of the target path, stored in the backup storage folder.
        """
        date_string = datetime.now().strftime(self.date_format)
        backup_name = f"{self.target_path.name}{self.separator}{date_string}.zip"
        backup_path = self.backup_storage.get_file(backup_name)
        with ZipFile(backup_path, mode="w") as zip_file:
            for item in self.target_path.glob("**/*"):
                zip_file.write(item, item.relative_to(self.target_path))

    def get_backups(self):
        """
        Get all backups found in the given folder.
        """
        return self.backup_storage.list_files(f"{self.target_path.stem}{self.separator}*.zip")

    def get_delete_candidates(self, max_backup_count) -> list[Path]:
        """
        Get all candidates for deletion with the given max_backup_count.
        If none are available for deletion, returns None.
        """
        def get_date(file: Path) -> datetime:
            """
            Turns the datetime string in the file name into a datetime object.
            """
            date_string = file.name.split(self.separator)[1].replace(file.suffix, "")
            return datetime.strptime(date_string, self.date_format)

        backups = self.get_backups()
        backups.sort(key=get_date)
        return backups[:(len(backups)-max_backup_count)]  # returns the oldest excess backups

    def delete_excess_backups(self, max_backup_count: int):
        """Delete all excess backups"""
        for file in self.get_delete_candidates(max_backup_count):
            file.unlink()
