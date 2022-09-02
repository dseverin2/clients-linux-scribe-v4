#!/bin/bash


#### installation du proxy authentifiant ####
# - evite les popup intempestive
# - ver 1.0.0
# - 10 Avril 2018
# - CALPETARD Olivier - AMI - lycee Antoine ROUSSIN

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

#determiner le repertoire de lancement
updatedb
locate version_esubuntu.txt > files_tmp
sed -i -e "s/version_esubuntu.txt//g" files_tmp
read chemin < files_tmp
echo $chemin

###########################################################################
#Paramétrage par défaut
#Changez les valeurs, ainsi, il suffira de taper 'entrée' à chaque question
###########################################################################
nom_etab="Lycée Antoine ROUSSIN"
proxy="172.18.40.1:3128"
port_cntlm="3128"
type_cntlm="LM"
proxy_gnome_noproxy="[ 'localhost', '127.0.0.0/8', '172.18.40.0/21', '192.168.0.0/16', '*.roussin.lan' ]"
proxy_env_noproxy="localhost,127.0.0.1/8,192.168.0.0/16,172.18.40.0/21,.roussin.lan"
nom_domaine="SCRIBE-ROUSSIN"
sos_info="en salle 209"


#creation des parametres etablmissement
#Nom de l'établissement
read -p "Entrez le nom del'établissement: [$nom_etab] " etab
if [ "$etab" = "" ] ; then
  etab=$nom_etab
fi
echo "NOM_ETAB=\"$etab\"" > "$chemin"esubuntu/param_etab.conf


read -p "Entrez le nom de domaine: : [$nom_domaine] " domaine
if [ "$domaine" = "" ] ; then
  domaine=$nom_domaine
fi
echo "DOMAINENAME=\"$domaine\"" >> "$chemin"esubuntu/param_etab.conf

read -p "Entrez le proxy : [$proxy] " proxy_etab
if [ "$proxy_etab" = "" ] ; then
  proxy_etab=$proxy
fi
echo "PROXY=\"$proxy_etab\"" >> "$chemin"esubuntu/param_etab.conf


read -p "Entrez les execptions proxy séparé par des virgules :  : [$proxy_env_noproxy] " proxy_out
if [ "$proxy_out" = "" ] ; then
  proxy_out=$proxy_env_noproxy
fi
echo "NOPROXY=\"$proxy_out\"" >> "$chemin"esubuntu/param_etab.conf


read -p "Entrez le port du cntlm autre que 3129 : [$port_cntlm] " cntlm_lis
if [ "$cntlm_lis" = "" ] ; then
  cntlm_lis=$port_cntlm
fi
echo "PORTCNTLM=\"$cntlm_lis\"" >> "$chemin"esubuntu/param_etab.conf


read -p "Entrez le type autentification LM NT NTLMv2 : [$type_cntlm] " cntlm_aut
if [ "$cntlm_aut" = "" ] ; then
  cntlm_aut=$type_cntlm
fi
echo "TYPE_AUTH=\"$cntlm_aut\"" >> "$chemin"esubuntu/param_etab.conf


read -p "Entrez la salle ou téléphone du service informatique: [$sos_info] " sos_si
if [ "$sos_si" = "" ] ; then
  sos_si=$sos_info
fi
echo "AIDE=\"$sos_si\"">> "$chemin"esubuntu/param_etab.conf


#installation de cntlm 
sudo apt-get install cntlm 

# copie des fichiers
sudo cp "$chemin"esubuntu/cntlm.sh /etc/esubuntu/
sudo cp "$chemin"esubuntu/reconf_cntlm.sh /etc/esubuntu/
sudo chmod +x /etc/esubuntu/*.sh
sudo cp "$chemin"xdg_autostart/cntlm.desktop /etc/xdg/autostart/
sudo chmod +x /etc/xdg/autostart/cntlm.desktop
sudo cp "$chemin"esubuntu/param_etab.conf /etc/esubuntu/
sudo chmod 755 /etc/esubuntu/param_etab.conf

#configuration de cntlm système pour ne pas faire d'interférence avec celui de lutilisateur

echo "Username	admin
Domain		$domaine
Auth		$cntlm_aut
Proxy		$proxy_etab
NoProxy		$proxy_out
Listen		3129" > /etc/cntlm.conf


echo "penser a modifier les paramétre proxy dans firefox.js et dans gset par 127.0.0.1:$cntlm_lis"
exit
