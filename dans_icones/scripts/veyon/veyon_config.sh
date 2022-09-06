#!/bin/bash
str1=`cat /etc/hostname`;
salle="";
config=0;

for a in LABO TECHNO INFO; 
do
	if [[ $str1 =~ $a* ]]; then
		salle=$a;
		echo Importation de la configuration;
		sudo /usr/bin/veyon-cli config import /media/Serveur_Scribe/commun/logiciels/Veyon/$salle/config-generale.json;
	fi
done
