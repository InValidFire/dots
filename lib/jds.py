from pathlib import Path
import re

from .storage import StorageRoot, StorageFolder

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

    def get_bucket(self, bucket: StorageFolder | Path | str) -> StorageFolder:
        """
        Get the requested bucket.
        If it cannot be found, return the JDS root instead.
        """
        buckets = self.get_buckets()
        if isinstance(bucket, str):
            bucket = str(int(bucket) - (int(bucket) % 10))
            for folder in buckets:
                if bucket in folder.path.name:
                    return folder
        elif isinstance(bucket, Path):
            for folder in buckets:
                if bucket == folder.path:
                    return folder
        elif isinstance(bucket, StorageFolder):
            return bucket
        return self

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

    def get_category(self, category: StorageFolder | Path | str) -> StorageFolder:
        """
        Get the requested category.
        If it cannot be found, try to return the bucket instead.
        """
        categories = self.get_categories()
        if isinstance(category, str):
            for folder in categories:
                if category in folder.path.name:
                    return folder
        elif isinstance(category, Path):
            for folder in categories:
                if category == folder.path:
                    return folder
        elif isinstance(category, StorageFolder):
            return category
        return self.get_bucket(category)

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

    def get_item(self, jd_number: str) -> StorageFolder:
        """
        Gets the requested item by Johnny Decimal Number. 
        If it cannot be found, try to return the category instead.
        """
        category_id, item_id = jd_number.split(".")  # TODO: Improve this algorithm
        try:
            int(category_id)
            int(item_id)
        except ValueError as exc:
            raise ValueError(f"'{jd_number}' is not a valid JDN") from exc
        category = self.get_category(category_id)
        for item in category.get_folders():
            if item_id in item.path.name:
                return item
        return self.get_category(category_id)
