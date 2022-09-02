#!/bin/bash

## Indiquer ici ce que vous voulez installer, exemple pour VLC (sans le # au début évidemment !)

if [ ! -e /usr/share/wallpaper/Administratif.jpg ]; then
	sudo cp /tmp/netlogon/icones/linux-port/wallpaper/* /usr/share/wallpaper/
fi
sudo apt remove -y anydesk hplip hplip-doc hplip-gui chrome firefox-esr
sudo apt install -y firefox
sudo apt autoremove --purge -y
sudo apt install libdvd-pkg -y
