#!/bin/bash

echo "--- Configuration des installations"
sudo dpkg --configure -a
sudo apt install --fix-broken -y

sudo apt install gucharmap orca okular flameshot cheese -y
source /tmp/netlogon/icones/scripts/installScripts/installOBS.sh
source /tmp/netlogon/icones/scripts/installScripts/installFilius.sh
source /tmp/netlogon/icones/scripts/installScripts/installSweetHome.sh

echo "--- Mise à jour des paquets"
sudo apt full-upgrade -y

echo "--- Nettoyage des fichiers"
# Nettoyage (Ne jamais enlever)
sudo apt autoremove --purge -y
sudo apt-get clean -y
