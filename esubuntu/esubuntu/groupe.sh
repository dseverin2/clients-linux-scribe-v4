#!/bin/bash

#### utilitaire pour upkg ####
# - récupère la valeur du groupe et execute upkg_client si 
# - ver 2.4
# - 28 septembre 2022
# - CALPETARD Olivier
# - SEVERIN Didier

#administratif = 10000 //  prof = 10001  // eleve = 10002
groupe=$GROUPS 				

netlogonIcons="/tmp/netlogon/icones"
esublogdir="$HOME/.esubuntu"
if [ ! -d $esublogdir ]; then mkdir $esublogdir; fi
grouplogfile="$esublogdir/groupe-sh.log"
echo "LOG de /etc/esubuntu/groupe.sh lancé par $USER" > $grouplogfile
echo `date` >> $grouplogfile

case $groupe in
10000)
	usergrp="administratif"
	;;
10001)
	usergrp="prof"
	;;
10002)
	usergrp="élève"
	;;
*)
	usergrp="undefined"
	;;
esac
echo "Groupe trouvé : $usergrp" >> $grouplogfile


if [ "$usergrp" != "undefined" ]; then
 	if [ -f $netlogonIcons/scripts/liste_pc_esu.csv ]; then 
		echo "La liste $netlogonIcons/scripts/liste_pc_esu.csv existe" >> $grouplogfile
		
		#recherche nom du pc et son groupe dans le fichier
		adresseMAC=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address)
		nom=$(grep $adresseMAC $netlogonIcons/scripts/liste_pc_esu.csv | awk -F',' ' {gsub("\r","",$2); printf $2 } ' )
		salle=$(grep $adresseMAC $netlogonIcons/scripts/liste_pc_esu.csv | awk -F',' ' {gsub("\r","",$1); printf $3 } ' )
	
		if [ -z "$salle" ]; then
			echo "le pc n'existe pas dans la liste" >> $grouplogfile
			salle=linux-grp_eole
		else
			salle=$salle
			nom=$nom
		fi
	
		regname=$(cat /etc/hostname)
		if [ "$regname" = "$nom" ]; then
			echo "Hostname est correctement renseigné / NOM_PC : $nom" >> $grouplogfile
		else
			echo "Mise à jour de hostname / NOM_PC : $nom" >> $grouplogfile
			echo "$nom" > /etc/hostname
		fi	
	
		gm_esu=$(cat /etc/GM_ESU)

		if [ $gm_esu != $salle ]; then
			echo "Nouveau groupe de machines : $salle" >> $grouplogfile
			echo "$salle" > /etc/GM_ESU

			#firefox

			gm_esu=$(cat /etc/GM_ESU)
			echo '//
pref("autoadmin.global_config_url", "file://$netlogonIcons/'$gm_esu'/linux/firefox.js", locked); ' > /usr/lib/firefox/firefox.cfg
		else
			echo "Même groupe de machines : $salle" >> $grouplogfile
		fi
		cp -f $netlogonIcons/$gm_esu/linux/chromium/master_preferences /etc/chromium-browser/
	else 
		echo "ERREUR : La liste $netlogonIcons/scripts/liste_pc_esu.csv n'existe pas" >> $grouplogfile
	fi
else 
	echo "ERREUR : Groupe de l'utilisateur incorrect : gid $groupe" >> $grouplogfile
	echo  "Groupe de l'utilisateur incorrect" >> $grouplogfile
	exit 0
fi

#execution de upkg
sudo sh /etc/esubuntu/upkg_client.sh >> $grouplogfile
exit 0
