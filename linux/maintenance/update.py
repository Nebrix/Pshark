import os
from time import sleep
from pathlib import Path

# Define relative paths based on the script's location
BASE_DIR = os.path.dirname(os.path.abspath(__file__))  # Get the directory of the script

EXIT_SUCCESS = 0
REPOSITORY_LINK = "https://github.com/SecLabX/Pshark.git"

def update():
    # Cache Stuff

    cache_dir = os.path.join(BASE_DIR, "cache")
    os.makedirs(cache_dir, exist_ok=True)  # Create cache directory if it doesn't exist
    os.system(f"git clone {REPOSITORY_LINK} {cache_dir}")
    cache_file = os.path.join(cache_dir, "version")

    sleep(5)

    PSHARK_CACHE = os.path.join(BASE_DIR, "cache")
    VERSION_PATH = os.path.join(PSHARK_CACHE, "version")

    sleep(5)

    version_data = open(VERSION_PATH, "r")
    VERSION = version_data.read()
    sleep(1)
    version_data.close()

    # gets the version data of the current installation ^^^

    print(VERSION)

    if os.path.exists(cache_file):
        with open(cache_file, "r") as cache_data:
            if VERSION == cache_data.read():
                print("You're already up to date!")
                os.system(f"rm -rf {cache_dir}")

    os.system(f"rm -rf {cache_dir}")
    os.system(f"git pull {REPOSITORY_LINK}")

    return EXIT_SUCCESS

# Example usage
if __name__ == "__main__":
    update()
