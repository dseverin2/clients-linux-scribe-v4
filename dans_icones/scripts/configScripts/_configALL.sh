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
		sudo apt install -y g++ libc6-dev make cmake qtbase5-dev qtbase5-private-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools qtdeclarative5-dev qtquickcontrols2-5-dev libfakekey-dev xorg-dev libxtst-dev libjpeg-dev zlib1g-dev libssl-dev libpam0g-dev libprocps-dev liblzo2-dev libqca-qt5-2-dev libldap2-dev libsasl2-dev libprocps8 veyon
	fi
	echo Importation de la configuration;
	sudo /usr/bin/veyon-cli authkeys import professeurs/private ~/commun/logiciels/Veyon/Keys/private/professeurs/key
	sudo /usr/bin/veyon-cli authkeys import professeurs/public ~/communn/logiciels/Veyon/Keys/public/professeurs/key
	sudo /usr/bin/veyon-cli config import ~/commun/logiciels/Veyon/config.json;
else
	echo Pas de salle trouvée pour $str1;
fi

echo "--- Configuration de la photocopieuse"
# Vérification de la version du gestionnaire de code PIN photocopieuse (Ne jamais enlever)
echo "Recuperation du gestionnaire code de photocopieuse"

sudo wget https://raw.githubusercontent.com/dseverin2/clients-linux-scribe-v4/main/apps/recup_pin/recup_pin.sh -O /tmp/recup_pin.sh
if grep "DefaultKmManagement" /tmp/recup_pin.sh  > /dev/null; then
	sudo cmp /tmp/recup_pin.sh /usr/bin/recup_pin/recup_pin.sh 1>/dev/null 2>&1;
	if [ $? -eq 1 ]; then
		sudo mv /tmp/recup_pin.sh /usr/bin/recup_pin/recup_pin.sh
		sudo chmod 0755 /usr/bin/recup_pin/recup_pin.sh
	fi
fi
if [ -s /etc/cups/ppd/PHOTOCOPIEUSE_SDP ]; then
	chmod 0777 /etc/cups/ppd/PHOTOCOPIEUSE_SDP.ppd
fi

#
echo "--- Vérification màj esubuntu"
for i in background groupe conky_scribe; do
	sudo wget https://raw.githubusercontent.com/dseverin2/clients-linux-scribe-v4/main/esubuntu/esubuntu/$i.sh -O /tmp/$i.sh
	if grep "#!/bin/bash" /tmp/$i.sh; then
		sudo cmp /tmp/$i.sh /etc/esubuntu/$i.sh 1>/dev/null 2>&1;
		if [ $? -eq 1 ]; then
			sudo cp -f /tmp/$i.sh /etc/esubuntu/$i.sh
		fi
	fi
done

sudo chmod 0755 /etc/esubuntu/*.sh
