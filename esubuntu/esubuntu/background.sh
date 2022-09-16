#!/bin/bash

#### changement de fond ecran ouverture de session ubuntu ####
# - récupère la valeur du groupe et attribue en fonction les fonds ecran générés par esu
# - gestion des restriction gsetting
# - Préparation des icônes du bureau
# - ver 2.8
# - 31 août 2022
# - CALPETARD Olivier
# - SEVERIN Didier 

esublogfile="/tmp/esubbackground.log"

echo `date` > $esublogfile
groupe=$GROUPS

#les fichiers se trouvent dans icones$ 
#lecture du groupe ESU
gm_esu=linux-grp_eole

if [ -f "/etc/GM_ESU" ];then
	echo "Le PC est dans le groupe esu"
	gm_esu=$(cat /etc/GM_ESU)
fi

echo "Le PC est dans le groupe esu $gm_esu" >> $esublogfile

sleep 2


######################################################################
#                            PARAM ICONES DE BUREAU                  #
######################################################################

#lecture parametres utilisateur
if [ "$UID" = "10000" ]; then
	variable=Admin
	rm -f $HOME/Desktop/*.desktop
	cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/
	cp -fr /tmp/netlogon/icones/$gm_esu/DomainAdmins/Bureau/*  $HOME/Desktop/

	# Récupération des icones des autres types d'utilisateurs
	rm -fr $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/
	mkdir -p $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs
	cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/
	cp -fr /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/*  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/

	mkdir -p $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves
	cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/
	cp -fr /tmp/netlogon/icones/$gm_esu/eleves/Bureau/*  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/	
else
	case $groupe in
	10001)
		variable=Prof
		rm -f $HOME/Desktop/*.desktop
		cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/
		cp -fr /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/*  $HOME/Desktop/
		;;
	10002)
		variable=Eleve
		rm -f $HOME/Desktop/*.desktop
		cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/
		cp -fr /tmp/netlogon/icones/$gm_esu/eleves/Bureau/*  $HOME/Desktop/
		;;
	10004)
		variable=Administratif
		rm -f $HOME/Desktop/*.desktop
		cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/
		cp -fr /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/*  $HOME/Desktop/
		;;
	*)
		variable=undefined
		echo "Groupe trouvé : $variable" >> $esublogfile
		gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Images/images.jpg"
		exit 0
		;;
	esac
fi

# Définition du flag "trusted" pour tous les raccourcis du bureau
find ~/Bureau/ -type f -name *.desktop -exec gio set {} metadata::trusted true \; -exec chmod a+x {} \;

# Pour sketchup 8 (install partagée playonlinux)
if [ -e /usr/local/bin/sketchup.sh ]; then
    bash -c "sudo /usr/local/bin/sketchup.sh $(whoami) > ~/.sketchup.log 2>&1"
fi
echo "Groupe trouvé : $variable" >> $esublogfile

######################################################################
#                            PARAM WALLPAPER                         #
######################################################################

wallpaper=$(cat /tmp/netlogon/icones/$gm_esu/$variable.txt)
echo "Wallpaper : $wallpaper" >> $esublogfile

#pour ubuntu mate
if [ "$XDG_CURRENT_DESKTOP" = "MATE" ] ; then
	gsettings set org.mate.background picture-filename "$wallpaper"
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	xsetbg -onroot -fullscreen "$wallpaper"
	for a in 0 1; do
		for b in 0 1 2 3 4 5; do
			xfconf-query -c xfce4-desktop -p /backdrop/screen$a/monitorVirtual$b/workspace0/last-image -s "$wallpaper"
		done
	done
else
	gsettings set org.gnome.desktop.background picture-uri "file:///"$wallpaper""
fi

######################################################################
#                            PARAM CONKY                             #
######################################################################
echo "Lancement de conky avec lecture du fichier de conf :" >> $esublogfile
cat /tmp/netlogon/icones/$gm_esu/conky/conky.cfg >> $esublogfile
cp /tmp/netlogon/icones/$gm_esu/conky/conky.cfg ~/.conky.cfg -fr

# Récupération de l'interface ethernet active
interfaceeth=$(ifconfig | grep UP,BROADCAST,RUNNING,MULTICAST | awk '{print $1}' | sed 's/://g')
if grep "Adresse IP : \${addr INTERFACEETH}" ~/.conky.cfg > /dev/null; then
	sed -i "s/Adresse IP : \${addr INTERFACEETH}/Adresse IP : \${addr $interfaceeth}/g" ~/.conky.cfg >> $esublogfile
fi
if grep "SALLEESU" ~/.conky.cfg > /dev/null; then
	sed -i "s/SALLEESU/$gm_esu/g" ~/.conky.cfg >> $esublogfile
fi
conky -c ~/.conky.cfg


######################################################################
#                            PARAM GSET                              #
######################################################################
echo "Lancement du gpo lecture fichier gset du groupe esu :" >> $esublogfile
cp /tmp/netlogon/icones/$gm_esu/linux/gset/gset.sh /tmp
chmod +x /tmp/gset.sh
/tmp/gset.sh
rm /tmp/gset.sh
echo "Fin" >> $esublogfile
exit 0
