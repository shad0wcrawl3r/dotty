import os
import subprocess
from random import randint
from pprint import pprint as print
from time import sleep

wallpaperDirectory = "/home/ashwin/Pictures/"
images = os.listdir(wallpaperDirectory)
print(images)


def get_random_image():
    return images[randint(0, len(images) - 1)]


while True:
    image = get_random_image()
    subprocess.call(
        f'hyprctl hyprpaper preload "{wallpaperDirectory}{image}"', shell=True
    )
    subprocess.call(
        f'hyprctl hyprpaper wallpaper ",contain:{wallpaperDirectory}{image}"',
        shell=True,
    )
    subprocess.call("hyprctl hyprpaper unload unused", shell=True)
    print(image)
    sleep(1)
    input()
