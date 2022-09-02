#!/bin/bash
#### installation et complement script dane de lyon ####
# - installation du pc dans un groupe et gestion proxy authentifie
# - ver 2.0.3
# - 18 Mai 2018
# - CALPETARD Olivier - AMI - lycee Antoine ROUSSIN

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Téléchargement des paquets
#git  clone https://github.com/dane-lyon/Esubuntu.git

# Affectation à la variable "version" suivant la variante utilisé
. /etc/lsb-release
if [ "$DISTRIB_RELEASE" = "14.04" ] || [ "$DISTRIB_RELEASE" = "17" ] || [ "$DISTRIB_RELEASE" = "17.3" ] ; then
  version=trusty # Ubuntu 14.04 / Linux Mint 17/17.3
fi
if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18" ] || [ "$DISTRIB_RELEASE" = "18.3" ] || [ "$(echo "$DISTRIB_RELEASE" | cut -c -3)" = "0.4" ] ; then
  version=xenial # Ubuntu 16.04 / Linux Mint 18/18.3 / Elementary OS 0.4.x
fi

#determiner le repertoire de lancement
updatedb
locate version_esubuntu.txt > files_tmp
sed -i -e "s/version_esubuntu.txt//g" files_tmp
read chemin < files_tmp
echo $chemin

chmod -R +x $chemin

#creation du dossier upkg et esubuntu
sudo mkdir /usr/local/upkg_client/
sudo mkdir /etc/esubuntu/

sudo chmod 777 /usr/local/upkg_client

#installation de cntlm zenity et conky
if [ "$version" = "trusty" ] || [ "$version" = "xenial" ] ; then  #ajout du ppa uniquement pour trusty et xenial
    add-apt-repository -y ppa:vincent-c/conky #conky est backporté pour avoir une version récente quelque soit la distrib
    apt-get update
fi
apt-get install -y zenity conky conky-all


#on lance la copie des fichier
sudo cp "$chemin"esubuntu/* /etc/esubuntu/
sudo chmod +x /etc/esubuntu/*.sh
sudo cp "$chemin"xdg_autostart/* /etc/xdg/autostart/
sudo chmod +x /etc/xdg/autostart/cntlm.desktop
sudo chmod +x /etc/xdg/autostart/message_scribe.desktop
sudo chmod +x /etc/xdg/autostart/scribe_background.desktop
sudo chmod 755 /etc/esubuntu/param_etab.conf

#on lance la gestion du groupe
#salle du pc
echo "Entrez le groupe ESU (salle): "
read salle

echo "$salle" > /etc/GM_ESU

#on lance le script prof_firefox en mode sudo 

sudo "$chemin"firefox/prof_firefox.sh

#on inscrit la tache upkg dans crontab
#avant je fesait sudo crontab -e

echo "*/15 *  * * * root /etc/esubuntu/groupe.sh" > /etc/crontab

##############################################################################
### Utilisation d'un proxy authentifiant
##############################################################################
read -p "Voulez-vous activer laprise en charge du proxy authentifiant? [o/N] :" proxauth

########################################################
# Téléchargement + Mise en place du proxy authentifiant
########################################################
if [ "$proxauth" = "O" ] || [ "$proxauth" = "o" ] ; then 
  sudo "$chemin"install_proxy_auth.sh
else
  # supression du cntlm 
  rm -f /etc/xdg/autostart/cntlm*
  rm -f /etc/esubuntu/cntlm.sh
  rm -f /etc/esubuntu/reconf_cntlm.sh
  rm -f /etc/esubuntu/param_etab.conf
fi

## 3 dernières lignes non activés car ce script est appelé par l'autre (intgrdom) et il ne faut pas interrompre pendant l'install
#echo "C'est fini ! bienvenue dans le groupe $salle..."
#echo "Pour compléter le système installer un serveur apt-cacher et un poste pour gérer les impressions des autre"
#exit
