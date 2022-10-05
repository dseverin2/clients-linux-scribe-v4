#!/bin/bash
#### installation et complement script dane de lyon ####
# - installation du pc dans un groupe et gestion proxy authentifie
# - ver 2.4
# - 31 Août 2022
# - CALPETARD Olivier - AMI - lycee Antoine ROUSSIN
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
if [ -e $baserep/esub_functions.sh ]; then
  source $baserep/esub_functions.sh
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
    sudo add-apt-repository -E -y ppa:vincent-c/conky #conky est backporté pour avoir une version récente quelque soit la distrib
    apt-get update
fi
apt-get install -y zenity conky conky-all

writelog "---Copie des fichiers esubuntu de $chemin"/esubuntu/" vers /etc/esubuntu"
for i in background conky_scribe groupe message upkg_client; do
	cp "$chemin"/esubuntu/$i.sh /etc/esubuntu/ -f
	chmod a+x /etc/esubuntu/*.sh
done
cp "$chemin"/xdg_autostart/message* /etc/xdg/autostart/ -f
cp "$chemin"/xdg_autostart/scribe* /etc/xdg/autostart/ -f

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
if [ "$salle" != "linux-grp_eole" ]; then
	cp -fr $baserep/dans_icones/groupe_esu $baserep/dans_icones/linux-grp_eole
fi

##############################################################################
### Auto paramétrage de gset, firefox et conky
##############################################################################
sudo -u "$SUDO_USER" find $baserep/dans_icones/groupe_esu/ -type f -exec sed -i -e "s/RNE_ETAB/$rne_etab/g" -e "s/IP_SCRIBE/$scribe_def_ip/g" -e "s/IP_PRONOTE/$pronote/g" -e "s/PORTAIL/$portail/g" -e "s/SALLEESU/$salle/g" -e "s/PROXY_IP/$proxy_def_ip/g" -e "s/PROXY_PORT/$proxy_def_port/g" -e "s/GSETPROXYPORT/$gset_proxy_port/g" -e "s/GSETPROXY/$gset_proxy/g" -e "s/SUBNET/$subnet/g" {} \; 2>> $logfile
sudo -u "$SUDO_USER" find $baserep/esubuntu/icones/gm_esu/ -type f -exec sed -i -e "s/RNE_ETAB/$rne_etab/g" -e "s/IP_SCRIBE/$scribe_def_ip/g" -e "s/IP_PRONOTE/$pronote/g" -e "s/PORTAIL/$portail/g" -e "s/SALLEESU/$salle/g" -e "s/PROXY_IP/$proxy_def_ip/g" -e "s/PROXY_PORT/$proxy_def_port/g" -e "s/GSETPROXYPORT/$gset_proxy_port/g" -e "s/GSETPROXY/$gset_proxy/g" -e "s/SUBNET/$subnet/g" {} \; 2>> $logfile
if [ "$salle" != "linux-grp_eole" ]; then
	sudo -u "$SUDO_USER" find $baserep/dans_icones/linux-grp_eole/ -type f -exec sed -i -e "s/RNE_ETAB/$rne_etab/g" -e "s/IP_SCRIBE/$scribe_def_ip/g" -e "s/IP_PRONOTE/$pronote/g" -e "s/PORTAIL/$portail/g" -e "s/SALLEESU/linux-grp_eole/g" -e "s/PROXY_IP/$proxy_def_ip/g" -e "s/PROXY_PORT/$proxy_def_port/g" -e "s/GSETPROXYPORT/$gset_proxy_port/g" -e "s/GSETPROXY/$gset_proxy/g" -e "s/SUBNET/$subnet/g" {} \; 2>> $logfile
fi
sudo -u "$SUDO_USER" find $baserep/esubuntu/ -type f -exec sed -i -e "s/BROWSERSTARTPAGE/$pagedemarragepardefaut/g" -e "s/PORTAIL/$portail/g" {} \; 2>> $logfile
sudo -u "$SUDO_USER" find $baserep/dans_icones/ -type f -exec sed -i -e "s/BROWSERSTARTPAGE/$pagedemarragepardefaut/g" -e "s/PORTAIL/$portail/g" {} \; 2>> $logfile

##############################################################################
### Utilisation d'un proxy authentifiant
##############################################################################

writelog "INITBLOC" "Téléchargement + Mise en place du proxy authentifiant"

if [ "$proxauth" = "true" ] ; then 
	"$chemin"/install_proxy_auth.sh
fi
chmod +x /etc/xdg/autostart/*.desktop
chmod 755 /etc/esubuntu/param_etab.conf
writelog "ENDBLOC"

mv $baserep/dans_icones/groupe_esu "$baserep/dans_icones/$salle" 2>> $logfile

writelog "INITBLOC" "Création des fichiers de log"
esublogdir="$HOME/.esubuntu"
addtoend /etc/profile "if [ ! -d $esublogdir ]; then mkdir $esublogdir; fi"
addtoend /etc/profile "for i in background upkgclient groupe; do echo > $esublogdir/$i-sh.log; done"

## 3 dernières lignes non activés car ce script est appelé par l'autre (intgrdom) et il ne faut pas interrompre pendant l'install
#echo "C'est fini ! bienvenue dans le groupe $salle..."
#echo "Pour compléter le système installer un serveur apt-cacher et un poste pour gérer les impressions des autres"
#exit
