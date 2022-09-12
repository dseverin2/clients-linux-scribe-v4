#!/bin/bash

echo "--- Configuration des installations"
sudo dpkg --configure -a
sudo apt install --fix-broken -y

# Suppression des paquets inutiles
echo "--- Suppression des paquets inutiles"
sudo apt remove -y wps-office*
sudo apt remove --purge mintwelcome android-studio-4.0 -y
sudo rm /etc/apt/sources.list.d/celestia* /etc/apt/sources.list.d/xia* -f
sudo apt autoremove -y

echo "--- Installation des logiciels"
# Update Libreoffice 7.2
if [ ! -e /usr/share/libreoffice7.2 ]; then
	sudo apt remove libreoffice -y
	sudo dpkg -i /media/Serveur_Scribe/commun/logiciels/apt/LibreOffice/LibreOffice_7.2.0_Linux_x86-64_deb/*.deb
	sudo touch /usr/share/libreoffice7.2
fi

source /tmp/netlogon/icones/scripts/installScripts/firefox-fr.sh
sudo apt install gucharmap orca okular snapd chromium flameshot cheese -y
if [ ! -e /usr/bin/chromium ]; then
	dpkg -i /media/Serveur_Scribe/commun/logiciels/apt/chromium_92.0.4515.159~linuxmint1+uma_amd64.deb
fi
source /tmp/netlogon/icones/scripts/installScripts/installOBS.sh
source /tmp/netlogon/icones/scripts/installScripts/installFilius.sh
source /tmp/netlogon/icones/scripts/installScripts/geogebra.sh
source /tmp/netlogon/icones/scripts/installScripts/scratux.sh
source /tmp/netlogon/icones/scripts/installScripts/installmBlock.sh
#source /tmp/netlogon/icones/scripts/installScripts/chrome.sh
source /tmp/netlogon/icones/scripts/installScripts/installActivInspire.sh
source /tmp/netlogon/icones/scripts/installScripts/installSweetHome.sh

echo "--- Mise à jour des paquets"
sudo apt full-upgrade -y

echo "--- Nettoyage des fichiers"
# Nettoyage (Ne jamais enlever)
sudo apt autoremove --purge -y
sudo apt-get clean -y
