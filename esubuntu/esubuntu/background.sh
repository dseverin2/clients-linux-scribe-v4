#!/bin/bash

#### changement de fond ecran ouverture de session ubuntu ####
# - récupère la valeur du groupe et attribue en fonction les fonds ecran générés par esu
# - gestion des restriction gsetting
# - Préparation des icônes du bureau
# - ver 2.8
# - 31 août 2022
# - CALPETARD Olivier
# - SEVERIN Didier 

logfile="/tmp/esubbackground.log"

echo `date` > $logfile
groupe=$GROUPS

#les fichiers se trouvent dans icones$ 
#lecture du groupe ESU
gm_esu=grp_eole

if [ -f "/etc/GM_ESU" ];then
	echo "Le PC est dans le groupe esu"
	gm_esu=$(cat /etc/GM_ESU)
fi

echo "Le PC est dans le groupe esu $gm_esu" >> $logfile

sleep 2


######################################################################
#                            PARAM ICONES DE BUREAU                  #
######################################################################

#lecture parametres utilisateur
if [ "$UID" = "10000" ]; then
	variable=Admin
	rm -f $HOME/Desktop/*.desktop
	cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*  $HOME/Desktop/
	cp -fr /tmp/netlogon/icones/$gm_esu/DomainAdmins/Bureau/  $HOME/Desktop/

	# Récupération des icones des autres types d'utilisateurs
	rm -fr $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/
	mkdir -p $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs
	cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/
	cp -fr /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/

	mkdir -p $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves
	cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/
	cp -fr /tmp/netlogon/icones/$gm_esu/eleves/Bureau/  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/	
else
	case $groupe in
	10001)
		variable=Prof
		rm -f $HOME/Desktop/*.desktop
		cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/  $HOME/Desktop/
		cp -fr /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/  $HOME/Desktop/
		;;
	10002)
		variable=Eleve
		rm -f $HOME/Desktop/*.desktop
		cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/  $HOME/Desktop/
		cp -fr /tmp/netlogon/icones/$gm_esu/eleves/Bureau/  $HOME/Desktop/
		;;
	10004)
		variable=Administratif
		rm -f $HOME/Desktop/*.desktop
		cp -fr /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/  $HOME/Desktop/
		cp -fr /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/  $HOME/Desktop/
		;;
	*)
		variable=undefined
		echo "Groupe trouvé : $variable" >> $logfile
		gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Images/images.jpg"
		exit 0
		;;
	esac
fi

# Définition du flag "trusted" pour tous les raccourcis du bureau
find ~/Desktop/ -type f -name "*.desktop" -exec gio set "{}" "metadata::trusted" yes \; -exec chmod a+x {} \;
find ~/Bureau/ -type f -name "*.desktop" -exec gio set "{}" "metadata::trusted" yes \; -exec chmod a+x {} \;

# Pour sketchup 8 (install partagée playonlinux)
if [ -e /usr/local/bin/sketchup.sh ]; then
    bash -c "sudo /usr/local/bin/sketchup.sh $(whoami) > ~/.sketchup.log 2>&1"
fi
echo "Groupe trouvé : $variable" >> $logfile

######################################################################
#                            PARAM WALLPAPER                         #
######################################################################

wallpaper=$(cat /tmp/netlogon/icones/$gm_esu/$variable.txt)
echo "Wallpaper : $wallpaper" >> $logfile

#pour ubuntu mate
if [ "$XDG_CURRENT_DESKTOP" = "MATE" ] ; then
	gsettings set org.mate.background picture-filename "$wallpaper"
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	xsetbg -onroot -fullscreen "$wallpaper"
else
	gsettings set org.gnome.desktop.background picture-uri "file:///"$wallpaper""
fi

######################################################################
#                            PARAM CONKY                             #
######################################################################
echo "Lancement de conky avec lecture du fichier de conf :" >> $logfile
cat /tmp/netlogon/icones/$gm_esu/conky/conky.cfg >> $logfile
cp /tmp/netlogon/icones/$gm_esu/conky/conky.cfg ~/.conky.cfg -fr

# Récupération de l'interface ethernet active
interfaceeth=$(ifconfig | grep UP,BROADCAST,RUNNING,MULTICAST | awk '{print $1}' | sed 's/://g')
if grep "Adresse IP : \${addr interfaceeth}" ~/.conky.cfg > /dev/null; then
	sed -i "s/Adresse IP : \${addr interfaceeth}/Adresse IP : \${addr $interfaceeth}/g" ~/.conky.cfg >> $logfile
fi
if grep "posteslinux" ~/.conky.cfg > /dev/null; then
	sed -i "s/posteslinux/$gm_esu/g" ~/.conky.cfg >> $logfile
fi
conky -c ~/.conky.cfg


######################################################################
#                            PARAM GSET                              #
######################################################################
echo "Lancement du gpo lecture fichier gset du groupe esu :" >> $logfile
cp /tmp/netlogon/icones/$gm_esu/linux/gset/gset.sh /tmp
chmod +x /tmp/gset.sh
/tmp/gset.sh
rm /tmp/gset.sh
echo "Fin" >> $logfile
exit 0
