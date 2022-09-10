#!/bin/bash
#### installation et complement script dane de lyon ####
# - installation du pc dans un groupe et gestion proxy authentifie
# - ver 2.4
# - 31 Août 2022
# - CALPETARD Olivier - AMI - lycee Antoine ROUSSIN
# - SEVERIN Didier - RRUPN - Collège Bois de Nèfles
# Dernière modification ligne 34 remplacement de locate par pwd

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Verification de la présence des fichiers contenant les fonctions et variables communes
basedir=$ (builtin cd ..; pwd )
if [ -e $basedir/esub_functions.sh ]; then
  source ./esub_functions.sh
  baserep=$basedir
else
  echo "Fichier esub_functions.sh absent ! Interruption de l'installation."
  exit
fi

# Récupération de la version d'ubuntu
getversion

writelog "---Détermination du répertoire de lancement"
updatedb

chemin=$(dirname $(realpath $0)) 
writelog "------Répertoire d'exec : $chemin"
gm_esu=$salle
writelog "------Groupe : $gm_esu"

writelog "---Création des dossiers upkg et esubuntu"
if [ -e /usr/local/upkg_client/ ]; then
	rm -fr /usr/local/upkg_client/
fi
sudo mkdir /usr/local/upkg_client/
sudo chmod 777 /usr/local/upkg_client

if [ -e /etc/esubuntu/ ]; then
	rm -fr /etc/esubuntu/
fi
sudo mkdir /etc/esubuntu/

writelog "---Installation de cntlm zenity et conky"
if [ "$version" = "trusty" ] || [ "$version" = "xenial" ] ; then
	writelog "------Ajout du ppa uniquement pour trusty et xenial"
    add-apt-repository -y ppa:vincent-c/conky #conky est backporté pour avoir une version récente quelque soit la distrib
    apt-get update
fi
apt-get install -y zenity conky conky-all

writelog "---Copie des fichiers esubuntu de $chemin"/esubuntu/" vers /etc/esubuntu" "---Et de "$chemin"/xdg_autostart vers /etc/xdg/autostart"
sudo cp "$chemin"/esubuntu/* /etc/esubuntu/
sudo chmod +x /etc/esubuntu/*.sh
sudo cp "$chemin"/xdg_autostart/* /etc/xdg/autostart/
writelog "---Attribution des droits sur les fichiers /etc/xdg/autostart"
sudo chmod +x /etc/xdg/autostart/cntlm.desktop
sudo chmod +x /etc/xdg/autostart/message_scribe.desktop
sudo chmod +x /etc/xdg/autostart/scribe_background.desktop
sudo chmod 755 /etc/esubuntu/param_etab.conf

writelog "INITBLOC" "---Gestion du groupe" "------Configuration de la salle"
echo "$salle" > /etc/GM_ESU

writelog "------Lancement du script prof_firefox en mode sudo"
sudo "$chemin"/firefox/prof_firefox.sh

writelog "------Inscription de upkg dans crontab"
echo "*/15 *  * * * root /etc/esubuntu/groupe.sh" > /etc/crontab
writelog "ENDBLOC"

##############################################################################
### Auto paramétrage de gset, firefox et conky
##############################################################################
sudo -u "$SUDO_USER" find $baserep/dans_icones/ -type f -exec sed -i -e "s/RNE_ETAB/"$rne_etab"/g" -e "s/IP_SCRIBE/"$scribe_def_ip"/g" -e "s/IP_PRONOTE/"$pronote"/g" -e "s/PORTAIL/"$portail"/g" -e "s/SALLEESU/"$salle"/g" {} \ ; 2>> $logfile
sudo -u "$SUDO_USER" find $baserep/dans_icones/ -type f -exec sed -i -e "s/PROXY_IP/"$proxy_def_ip"/g" -e "s/PROXY_PORT/"$proxy_def_port"/g" -e "s/GSETPROXYPORT/"$gset_proxy_port"/g" -e "s/GSETPROXY/"$gset_proxy"/g" -e "s/SUBNET/"$subnet"/g" {} \;  2>> $logfile
interfaceeth=`ip -br link | grep 'UP' | grep -v 'OWN' | awk '{ print $1 }'`
sudo -u "$SUDO_USER" find $baserep/dans_icones/ -type f -exec sed -i -e "s/INTERFACEETH/"$interfaceeth"/g" {} \; 2>> $logfile

# Ancien script :
if false; then
	if grep "posteslinux" "$chemin"/icones/gm_esu/linux/firefox.js > /dev/null; then
		sed -i "s/posteslinux/$gm_esu/g" "$chemin"/icones/gm_esu/linux/firefox.js 2>> $logfile
	fi
	sed -i -e "s/RNE_ETAB/$rne_etab/g" -e "s/IP_SCRIBE/$scribe_def_ip/g" -e "s/IP_PRONOTE/$pronote/g" -e "s/PORTAIL/$portail/g" -e "s/SALLEESU/$salle/g" "$chemin"/icones/gm_esu/linux/firefox.js 2>> $logfile

	sed -i -e "s/GSETPROXY/$gset_proxy/g" -e "s/SUBNET/$subnet/g" "$chemin"/icones/gm_esu/linux/gset/gset.sh 2>> $logfile

	if grep "INTERFACEETH" "$chemin"/icones/gm_esu/conky/conky.cfg > /dev/null; then
		sed -i "s/INTERFACEETH/$interfaceeth/g" "$chemin"/icones/gm_esu/conky/conky.cfg 2>> $logfile
	fi
fi
writelog "3/3-Autoparamétrage... OK"
##############################################################################
### Utilisation d'un proxy authentifiant
##############################################################################

writelog "INITBLOC" "Téléchargement + Mise en place du proxy authentifiant"

if [ "$proxauth" = "yes" ] ; then 
  sudo "$chemin"/install_proxy_auth.sh
else
  # supression du cntlm 
  rm -f /etc/xdg/autostart/cntlm*
  rm -f /etc/esubuntu/cntlm.sh
  rm -f /etc/esubuntu/reconf_cntlm.sh
  rm -f /etc/esubuntu/param_etab.conf
fi
writelog "ENDBLOC"

mv $baserep/dans_icones/groupe_esu "$baserep/dans_icones/$salle" 2>> $logfile

## 3 dernières lignes non activés car ce script est appelé par l'autre (intgrdom) et il ne faut pas interrompre pendant l'install
#echo "C'est fini ! bienvenue dans le groupe $salle..."
#echo "Pour compléter le système installer un serveur apt-cacher et un poste pour gérer les impressions des autres"
#exit
