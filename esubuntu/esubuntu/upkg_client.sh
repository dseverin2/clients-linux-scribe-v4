#!/bin/bash

#### chargement d'une tache en root pour installer une application a l'ouverture de session ubuntu ####
# - récupère le script script_install.sh et execute si et seulement si il n'a pas déja été fait
# - ver 1.2
# - 28 septembre 2022
# - CALPETARD Olivier
# - SEVERIN Didier


#les fichier se trouve dans icones$
#lancement de upkg client seulement si le compte utilisateur utilise une session scribe
gm_esu=linux-grp_eole
#lecture du groupe ESU
if [ -f "/etc/GM_ESU" ];then
echo "Le PC est dans le groupe esu"
gm_esu=$(cat /etc/GM_ESU)
fi

esublogdir="$HOME/.esubuntu"
if [ ! -d $esublogdir ]; then mkdir $esublogdir; fi
upkglogfile="$esublogdir/upkgclient-sh.log"
echo `date` > $upkglogfile
stamp=upkg

if [ -f /tmp/netlogon/icones/$gm_esu/linux/upkg/stamp.date ]; then
	cat /tmp/netlogon/icones/$gm_esu/linux/upkg/upkg.txt >/dev/null 2>&1; pkglist=$? 

	if [ $pkglist -eq 1 ]; then  
		echo "UPKG désactivé dans /tmp/netlogon/icones/$gm_esu/linux/upkg/upkg.txt" >> $upkglogfile
		exit 0
	elif [ -f /usr/local/upkg_client/stamp.date ]; then 
		if cmp -s /usr/local/upkg_client/stamp.date /tmp/netlogon/icones/$gm_esu/linux/upkg/stamp.date; then
			echo "/usr/local/upkg_client/stamp.date et /tmp/netlogon/icones/$gm_esu/linux/upkg/stamp.date IDENTIQUES" >> $upkglogfile
			stamp=nupkg
		else
			echo "/usr/local/upkg_client/stamp.date et /tmp/netlogon/icones/$gm_esu/linux/upkg/stamp.date DIFFERENTS" >> $upkglogfile
		fi
	else 
		echo "/usr/local/upkg_client/stamp.date n'existe pas CREATION" >> $upkglogfile
	fi
fi

if [ -f /tmp/netlogon/icones/$gm_esu/linux/upkg/script_install.sh ]; then
	echo "/tmp/netlogon/icones/$gm_esu/linux/upkg/script_install.sh OK" >> $upkglogfile
	if [ $stamp = "upkg" ]; then
		echo "Copie et lancement de script_install.sh vers /usr/local/upkg_client/" >> $upkglogfile
		cp /tmp/netlogon/icones/$gm_esu/linux/upkg/script_install.sh /usr/local/upkg_client/ 
		chmod +x /usr/local/upkg_client/script_install.sh
		/usr/local/upkg_client/script_install.sh
		echo "Copie de stamp.date vers /usr/local/upkg_client/ pour fin de mise à jour" >> $upkglogfile
		cp /tmp/netlogon/icones/$gm_esu/linux/upkg/stamp.date /usr/local/upkg_client/ 
	else 
		echo "stamp.date identiques - pas de mise à jour à réaliser" >> $upkglogfile
	fi
fi
exit 0

  
