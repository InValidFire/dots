from pathlib import Path
import re

from .storage import StorageRoot, StorageFile, StorageFolder

__all__ = ["JDS"]

class JDS(StorageRoot):
    def __init__(self, root: Path, bucket_regex = r"(^\d0)-(\d9)", 
                 category_regex = r"^(\d\d)", id_regex = r"^(\d\d)") -> None:
        self.bucket_regex = bucket_regex
        self.category_regex = category_regex
        self.id_regex = id_regex
        super().__init__(root)

    def get_buckets(self) -> list[StorageFolder]:
        folders = self.get_folders()
        temp = folders.copy()
        for folder in temp:
            folder_match = re.match(self.bucket_regex, folder.path.name)
            if folder_match is None:
                temp.remove(folder)
        temp.sort(key=lambda folder: folder.path)
        return temp

    def get_bucket(self, bucket: StorageFolder | Path | str) -> list[StorageFolder]:
        buckets = self.get_buckets()
        if isinstance(bucket, str):
            for folder in buckets:
                if bucket in folder.path.name:
                    return folder.get_folders()
        elif isinstance(bucket, Path):
            for folder in buckets:
                if bucket == folder.path:
                    return StorageFolder(bucket, self.root).get_folders()
        elif isinstance(bucket, StorageFolder):
            return bucket.get_folders()
        raise FileNotFoundError(bucket)

    def get_categories(self) -> list[StorageFolder]:  # TODO: Improve this algorithm
        buckets = self.get_buckets()
        categories = []
        for bucket in buckets:
            for folder in bucket.get_folders():
                folder_match = re.match(self.category_regex, folder.path.name)
                if folder_match is None:
                    continue
                categories.append(folder)
        return categories

    def get_category(self, category: StorageFolder | Path | str) -> list[StorageFolder]:
        categories = self.get_categories()
        if isinstance(category, str):
            for folder in categories:
                if category in folder.path.name:
                    return folder.get_folders()
        elif isinstance(category, Path):
            for folder in categories:
                if category == folder.path:
                    return folder.get_folders()
        elif isinstance(category, StorageFolder):
            return category.get_folders()
        raise FileNotFoundError(category)

    def get_items(self) -> list[StorageFolder]:  # TODO: Improve this algorithm
        buckets = self.get_buckets()
        categories = []
        for bucket in buckets:
            for folder in bucket.get_folders():
                folder_match = re.match(self.id_regex, folder.path.name)
                if folder_match is None:
                    continue
                categories.append(folder)
        return categories

    def get_item(self, jd_number: str) -> list[StorageFile]:
        category_id, item_id = jd_number.split(".")  # TODO: Improve this algorithm
        category = self.get_category(category_id)
        for item in category:
            if item_id in item.path.name:
                return item.get_files()
        raise FileNotFoundError(jd_number)
