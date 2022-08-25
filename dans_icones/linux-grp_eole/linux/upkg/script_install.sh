#!/bin/bash

sudo dpkg --configure -a

# Vérification de la version du gestionnaire de code PIN photocopieuse (Ne jamais enlever)
echo "Recuperation du gestionnaire code de photocopieuse"
sudo wget https://raw.githubusercontent.com/dseverin2/clients-linux-scribe/master/apps/recup_pin/recup_pin.sh -O /tmp/recup_pin.sh
sudo cmp /tmp/recup_pin.sh /usr/bin/recup_pin/recup_pin.sh 1>/dev/null 2>&1;
if [ $? -eq 1 ]; then
	sudo mv /tmp/recup_pin.sh /usr/bin/recup_pin/recup_pin.sh
	sudo chmod 0755 /usr/bin/recup_pin/recup_pin.sh
fi

# Vérification de la version du fichier groupe.sh
echo "Recuperation du gestionnaire de groupe EOLE"
sudo wget https://raw.githubusercontent.com/dseverin2/clients-linux-scribe/master/esubuntu/esubuntu/groupe.sh -O /tmp/groupe.sh
sudo cmp /tmp/groupe.sh /etc/esubuntu/groupe.sh 1>/dev/null 2>&1;
if [ $? -eq 1 ]; then
	sudo mv /tmp/groupe.sh /etc/esubuntu/groupe.sh
	sudo chmod 0755 /etc/esubuntu/groupe.sh
fi

if [ -e /etc/cups/ppd/PHOTOCOPIEUSE_SDP ]; then
	chmod 0777 /etc/cups/ppd/PHOTOCOPIEUSE_SDP.ppd
fi

# Suppression de la mise en veille
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Installations et Désinstallations (Modifiables)
echo "Installation des logiciels"
sudo apt install --fix-broken -y
source /tmp/netlogon/icones/scripts/installScripts/aptproxy.sh
sudo apt remove --purge mintwelcome -y
sudo apt install firefox okular -y
source /tmp/netlogon/icones/scripts/installScripts/geogebra.sh
source /tmp/netlogon/icones/scripts/installScripts/scratux.sh
source /tmp/netlogon/icones/scripts/installScripts/installSnap.sh
source /tmp/netlogon/icones/scripts/installScripts/chrome.sh
sudo apt full-upgrade -y

# Nettoyage (Ne jamais enlever)
sudo apt autoremove --purge -y
sudo apt-get clean -y
