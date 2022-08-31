#!/bin/bash
str1=`cat /etc/hostname`;
salle="";
config=0;

for a in LABO TECHNO INFO; 
do
	if [[ $str1 =~ $a* ]]; then
		salle=$a;
		config=1;
	fi
done
echo Salle $a trouvée pour le poste $str1;

if [ "$config" = "1" ]; then
	echo Importation de la configuration;
	sudo /usr/bin/veyon-cli config import /media/Serveur_Scribe/commun/logiciels/Veyon/$salle/config-generale.json;
fi
