#!/bin/bash


#### installation du proxy authentifiant ####
# - evite les popup intempestive
# - ver 1.1.0
# - 26 Mai 2020
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
  echo "Fichier $baserep/esub_functions.sh absent ! Interruption de l'installation."
  exit
fi

#determiner le repertoire de lancement
updatedb

#creation des parametres etablissement
sudo -u $SUDO_USER sed -i -e "s/NOMETAB/$nom_etab/g" -e "s/DOMAINNAME/$domaine_local/g" -e "s/PROXYIP/$proxy/g" -e "s/NO_PROXY/$proxy_env_noproxy_esc/g" -e "s/PORTCNTLM/$port_cntlm/g" -e "s/TYPE_AUTH/$type_cntlm/g" -e "s/AIDE/$sos_info/g" $baserep/esubuntu/esubuntu/param_etab.conf 2>> $logfile
#installation de cntlm 
sudo apt-get install cntlm 

# copie des fichiers
cp "$baserep"/esubuntu/xdg_autostart/cntlm.desktop /etc/xdg/autostart/
writelog "---Attribution des droits sur les fichiers /etc/xdg/autostart"
cp "$baserep"/esubuntu/esubuntu/*cntlm* /etc/esubuntu/ -f
cp "$baserep"/esubuntu/esubuntu/param_etab.conf /etc/esubuntu/ -f
sudo chmod +x /etc/esubuntu/*.sh
sudo chmod a+x /etc/xdg/autostart/*.desktop
sudo chmod 755 /etc/esubuntu/param_etab.conf

#configuration de cntlm système pour ne pas faire d'interférence avec celui de lutilisateur

echo "Username	admin
Domain		$domaine_local
Auth		$type_cntlm
Proxy		$proxy
NoProxy		$proxy_env_noproxy
Listen		3129" > /etc/cntlm.conf

sudo -u "$SUDO_USER"  sed -i -e "s/$proxy_def_port/$port_cntlm/g" -e "s/$proxy_def_ip/127.0.0.1/g" $baserep/esubuntu/icones/gm_esu/linux/firefox.js 2>> $logfile 
sudo -u "$SUDO_USER"  sed -i -e "s/$proxy_def_port/$port_cntlm/g" -e "s/$proxy_def_ip/127.0.0.1/g" $baserep/esubuntu/icones/gm_esu/linux/gset/gset.sh 2>> $logfile 

exit
