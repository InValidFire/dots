from pathlib import Path
import shutil
import sys, os, stat

source functions.xsh

DEBUG = True

def debug(text: str):
    if DEBUG:
        print(text)

print("Running system setup!")

#  TODO: first thing, set up bitwarden (used later to grab gpg password)

key_path: Path = Path(input("Enter key path: ")) #  path for ssh and gpg keys.

gpg_path: Path | None = None
ssh_path: Path | None = None
for path in key_path.iterdir():
    if path.is_dir() and path.name == "gpg":
        gpg_path = path
        debug(f"found gpg_path: {gpg_path}")
    elif path.is_dir() and path.name == "ssh":
        ssh_path = path
        debug(f"found ssh_path: {ssh_path}")

if gpg_path is None or ssh_path is None:
    print("Error locating paths.")
    sys.exit(1)

shutil.copy(ssh_path.joinpath("id_rsa"), Path.home().joinpath(".ssh"))
shutil.copy(ssh_path.joinpath("id_rsa.pub"), Path.home().joinpath(".ssh"))
print("Copied SSH keys...")

os.chmod(Path.home().joinpath(".ssh/id_rsa"), stat.S_IREAD)
os.chmod(Path.home().joinpath(".ssh/id_rsa.pub"), stat.S_IREAD)
print("Set SSH key permissions...")

requires("bw")
