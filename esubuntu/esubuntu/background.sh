#!/bin/bash

#### changement de fond ecran ouverture de session ubuntu ####
# - récupère la valeur du groupe et attribut en fonction les fond ecran génére par esu
# - gestion des restriction gsetting
# - Préparation des icônes du bureau
# - ver 2.6
# - 27 juin 2022
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

#lecture parametres utilisateur
if [ "$UID" = "10000" ]; then
	variable=Admin
	rm -f $HOME/Desktop/*.desktop
	cp /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*.desktop  $HOME/Desktop/
	cp /tmp/netlogon/icones/$gm_esu/DomainAdmins/Bureau/*.desktop  $HOME/Desktop/

	# Récupération des icones des autres types d'utilisateurs
	rm -fr $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/
	mkdir -p $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs
	cp /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*.desktop  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/
	cp /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/*.desktop  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/

	mkdir -p $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves
	cp /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*.desktop  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/
	cp /tmp/netlogon/icones/$gm_esu/eleves/Bureau/*.desktop  $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/	
	#chmod +x $HOME/Desktop/*.desktop $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Profs/*.desktop $HOME/Desktop/Bureaux\ Autres\ Utilisateurs/Eleves/*.desktop
else
	case $groupe in
	10001)
		variable=Prof
		rm -f $HOME/Desktop/*.desktop
		cp /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*.desktop  $HOME/Desktop/
		cp /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/*.desktop  $HOME/Desktop/
		#chmod +x $HOME/Desktop/*.desktop
		;;
	10002)
		variable=Eleve
		rm -f $HOME/Desktop/*.desktop
		cp /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*.desktop  $HOME/Desktop/
		cp /tmp/netlogon/icones/$gm_esu/eleves/Bureau/*.desktop  $HOME/Desktop/
		#chmod +x $HOME/Desktop/*.desktop
		;;
	10004)
		variable=Administratif
		rm -f $HOME/Desktop/*.desktop
		cp /tmp/netlogon/icones/$gm_esu/_Machine/Bureau/*.desktop  $HOME/Desktop/
		cp /tmp/netlogon/icones/$gm_esu/professeurs/Bureau/*.desktop  $HOME/Desktop/
		#chmod +x $HOME/Desktop/*.desktop
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
find ~/Desktop -type f -name "*.desktop" -exec gio set "{}" "metadata::trusted" yes \; -exec chmod a+x {} \;
find ~/Bureau -type f -name "*.desktop" -exec gio set "{}" "metadata::trusted" yes \; -exec chmod a+x {} \;

# Pour sketchup 8 (install partagée playonlinux)
if [ -e /usr/local/bin/sketchup.sh ]; then
    bash -c "sudo /usr/local/bin/sketchup.sh $(whoami) > ~/.sketchup.log 2>&1"
fi
echo "Groupe trouvé : $variable" >> $logfile

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
if grep "Adresse IP : \${addr ens5}" ~/.conky.cfg > /dev/null; then
	sed -i "s/Adresse IP : \${addr ens5}/Adresse IP : \${addr $interfaceeth}/g" ~/.conky.cfg >> $logfile
fi
conky -c ~/.conky.cfg

echo "Lancement du gpo lecture fichier gset du groupe esu :" >> $logfile
cp /tmp/netlogon/icones/$gm_esu/linux/gset/gset.sh /tmp
chmod +x /tmp/gset.sh
/tmp/gset.sh
rm /tmp/gset.sh
echo "Fin" >> $logfile
exit 0
