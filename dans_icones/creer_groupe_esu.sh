#!/bin/bash
#### installation et complement script dane de lyon ####
# - creation du groupe esu
# - ver 1.0
# - 08 Juillet 2022
# - SEVERIN Didier - RRUPN - Collège Bois de Nèfles

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Verification de la présence des fichiers contenant les fonctions et variables communes
if [ -e ./esub_functions.sh ]; then
	source ./esub_functions.sh
	# Création du fichier de log
	initlog
	writelog "1/3-Installation de net-tools et python"
	apt install net-tools python -y
	versionPython=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
	writelog "2/3-Fichiers de configuration... OK"
else
	echo "Fichier esub_functions.sh absent ! Interruption de l'installation."
	exit
fi

# Lancement de la configuration
if [ -e ./esub_functions.sh ]; then source ./Configurer.sh; fi
##############################################################################
### Auto paramétrage de gset, firefox et conky
##############################################################################
writelog "3/3-Autoparamétrage... OK"
sed -i -e "s/RNE_ETAB/"$rne_etab"/g" -e "s/IP_SCRIBE/"$scribe_def_ip"/g" -e "s/IP_PRONOTE/"$pronote"/g" -e "s/PORTAIL/"$portail"/g" -e "s/SALLEESU/"$salle"/g" ./groupe_esu/linux/firefox.js

sed -i -e "s/GSETPROXYPORT/"$gset_proxy_port"/g" -e "s/GSETPROXY/"$gset_proxy"/g" -e "s/SUBNET/"$subnet"/g" ./groupe_esu/linux/gset/gset.sh

interfaceeth=`ip -br link | grep 'UP' | grep -v 'OWN' | awk '{ print $1 }'`
sed -i -e "s/INTERFACEETH/"$interfaceeth"/g" ./groupe_esu/conky/conky.cfg
