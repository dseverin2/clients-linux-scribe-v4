#!/bin/bash

echo "--- Configuration de Veyon"
# Configuration de Veyon
str1=`cat /etc/GM_ESU`;
salle="";
config=0;

for a in labo techno info; do
	echo $str1 VS $a
	if [[ "$str1" =~ "$a"* ]]; then
		salle=$a;
		config=1;
		echo Salle $a trouvée pour $str1;
		break;
	fi
done

source /tmp/netlogon/icones/linux-grp_eole/firefox/prof_firefox.sh

if [ "$config" = "1" ]; then
	if [ ! -e /usr/bin/veyon-cli ]; then
		sudo apt install -y g++ libc6-dev make cmake qtbase5-dev qtbase5-private-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools qtdeclarative5-dev qtquickcontrols2-5-dev libfakekey-dev xorg-dev libxtst-dev libjpeg-dev zlib1g-dev libssl-dev libpam0g-dev libprocps-dev liblzo2-dev libqca-qt5-2-dev libldap2-dev libsasl2-dev
		sudo dpkg -i /media/Serveur_Scribe/commun/logiciels/LINUX/libprocps8_3.3.16-1ubuntu2_amd64.deb
		sudo dpkg -i /media/Serveur_Scribe/commun/logiciels/LINUX/veyon_4.5.4-0-ubuntu-focal_amd64.deb
	fi
	echo Importation de la configuration;
	sudo /usr/bin/veyon-cli authkeys import professeurs/private /media/Serveur_Scribe/commun/logiciels/Veyon/Keys/private/professeurs/key
	sudo /usr/bin/veyon-cli authkeys import professeurs/public /media/Serveur_Scribe/commun/logiciels/Veyon/Keys/public/professeurs/key
	sudo /usr/bin/veyon-cli config import /media/Serveur_Scribe/commun/logiciels/Veyon/config.json;
else
	echo Pas de salle trouvée pour $str1;
fi

echo "--- Configuration de la photocopieuse"
# Vérification de la version du gestionnaire de code PIN photocopieuse (Ne jamais enlever)
echo "Recuperation du gestionnaire code de photocopieuse"

sudo wget -nc https://github.com/dseverin2/clients-linux-scribe/raw/master/apps/recup_pin/recup_pin.sh -O /tmp/recup_pin.sh
if [ -s /tmp/recup_pin.sh ]; then
	sudo cmp /tmp/recup_pin.sh /usr/bin/recup_pin/recup_pin.sh 1>/dev/null 2>&1;
	if [ $? -eq 1 ]; then
		sudo mv /tmp/recup_pin.sh /usr/bin/recup_pin/recup_pin.sh
		sudo chmod 0755 /usr/bin/recup_pin/recup_pin.sh
	fi
fi
if [ -e /etc/cups/ppd/PHOTOCOPIEUSE_SDP ]; then
	chmod 0777 /etc/cups/ppd/PHOTOCOPIEUSE_SDP.ppd
fi

echo "--- Configuration du gestionnaire de bureau"
# Vérification de la version du gestionnaire de Bureau (Ne jamais enlever)
echo "Recuperation du gestionnaire de Bureau"
sudo cmp /tmp/netlogon/icones/scripts/esubuntu/background.sh /etc/esubuntu/background.sh 1>/dev/null 2>&1;
if [ $? -eq 1 ]; then
	sudo cp -f /tmp/netlogon/icones/scripts/esubuntu/background.sh /etc/esubuntu/background.sh
fi

# Vérification de la version du fichier groupe.sh
echo "Recuperation du gestionnaire de groupe EOLE"
sudo cmp /tmp/netlogon/icones/scripts/esubuntu/groupe.sh /etc/esubuntu/groupe.sh 1>/dev/null 2>&1;
if [ $? -eq 1 ]; then
	sudo cp -f /tmp/netlogon/icones/scripts/esubuntu/groupe.sh /etc/esubuntu/groupe.sh
fi

# Vérification de la version du fichier conky.sh
sudo cmp /tmp/netlogon/icones/scripts/esubuntu/conky_scribe.sh /etc/esubuntu/conky_scribe.sh
if [ $? -eq 1 ]; then
	sudo cp -f /tmp/netlogon/icones/scripts/esubuntu/conky_scribe.sh /etc/esubuntu/conky_scribe.sh
fi
sudo chmod 0755 /etc/esubuntu/*.sh
