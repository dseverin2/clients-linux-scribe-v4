#!/bin/bash

# Vérification de la version des wallpapers utilisés (Ne jamais enlever)
if [ ! -e /usr/share/wallpaper/Administratif.jpg ]; then
	sudo cp /tmp/netlogon/icones/linux-port/wallpaper/* /usr/share/wallpaper/
fi

# Vérification de la version du gestionnaire de code PIN photocopieuse (Ne jamais enlever)
local = /usr/bin/recup_pin/recup_pin.sh
distant = /tmp/recup_pin.sh
sudo wget https://raw.githubusercontent.com/dseverin2/clients-linux-scribe/master/apps/recup_pin/recup_pin.sh -O $distant
sudo cmp $local $distant 1>/dev/null 2>&1;
if [ $? -eq 1 ]; then
	sudo mv $distant $local
	sudo chmod 0755 $local
fi

# Installations et Désinstallations (Modifiables)
sudo apt remove -y anydesk hplip hplip-doc hplip-gui chrome firefox-esr
sudo apt install -y firefox libdvd-pkg okular

# Nettoyage (Ne jamais enlever)
sudo apt autoremove --purge -y
