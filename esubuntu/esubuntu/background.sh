#!/bin/bash

#### changement de fond ecran ouverture de session ubuntu ####
# - récupère la valeur du groupe et attribue en fonction les fonds ecran générés par esu
# - gestion des restriction gsetting
# - Préparation des icônes du bureau (ajout Sketchup 2017)
# - ver 3.0
# - 06 novembre 2022
# - CALPETARD Olivier
# - SEVERIN Didier 

esublogdir="$HOME/.esubuntu"	
if [ ! -d $esublogdir ]; then mkdir $esublogdir; fi
backgroundlogfile="$esublogdir/background-sh.log"
echo "LOG de /etc/esubuntu/groupe.sh lancé par $USER" > $backgroundlogfile
echo `date` >> $backgroundlogfile

groupe=$GROUPS

#les fichiers se trouvent dans icones$ 
#lecture du groupe ESU
gm_esu=linux-grp_eole

if [ -f "/etc/GM_ESU" ];then
	echo "Le PC est dans le groupe esu"
	gm_esu=$(cat /etc/GM_ESU)
fi

echo "Le PC est dans le groupe esu $gm_esu" >> $backgroundlogfile

sleep 3


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
		echo "Groupe trouvé : $variable" | tee -a $backgroundlogfile
		gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Images/images.jpg"
		exit 0
		;;
	esac
fi

# Pour sketchup 8 (install partagée playonlinux)
if [ -e /usr/local/bin/sketchup.sh ]; then # Sketchup 8
    bash -c "sudo /usr/local/bin/sketchup.sh $(whoami) > ~/.sketchup.log 2>&1"
elif [ -e /usr/local/bin/sketchup-shared.sh ]; then # Sketchup 2017
	bash -c "/usr/local/bin/sketchup-shared.sh $(whoami) > ~/.sketchup-shared.log 2>&1"
fi

# Définition du flag "trusted" pour tous les raccourcis du bureau
find ~/Bureau/ -type f -name *.desktop -exec gio set {} metadata::trusted true \; -exec chmod a+x {} \;
find ~/Desktop/ -type f -name *.desktop -exec gio set {} metadata::trusted true \; -exec chmod a+x {} \;

echo "Groupe trouvé : $variable" | tee -a $backgroundlogfile

######################################################################
#                            PARAM WALLPAPER                         #
######################################################################

wallpaper=$(cat /tmp/netlogon/icones/$gm_esu/$variable.txt)
echo "Wallpaper : $wallpaper" | tee -a $backgroundlogfile

#pour ubuntu mate
if [ "$XDG_CURRENT_DESKTOP" = "MATE" ] ; then
	gsettings set org.mate.background picture-filename "$wallpaper"
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	xsetbg -onroot -fullscreen "$wallpaper"
	for a in 0 1; do
		for b in 0 1 2 3; do
			xfconf-query -c xfce4-desktop -p /backdrop/screen$a/monitorVGA-$b/workspace0/last-image -s "$wallpaper"
		done
	done
else
	gsettings set org.gnome.desktop.background picture-uri "file:///"$wallpaper""
fi

######################################################################
#                            PARAM CONKY                             #
######################################################################
echo "Lancement de conky avec lecture du fichier de conf :" >> $backgroundlogfile
cp /tmp/netlogon/icones/$gm_esu/conky/conky.cfg ~/.conky.cfg -fr

# Récupération de l'interface ethernet active
#interfaceeth=`ip -br link | grep 'UP' | grep -v 'OWN' | awk '{ print $1 }'`
interfaceeth=$(ifconfig | grep UP,BROADCAST,RUNNING,MULTICAST | awk '{print $1}' | sed 's/://g')
if grep "Adresse IP : \${addr INTERFACEETH}" ~/.conky.cfg > /dev/null; then
	sed -i "s/Adresse IP : \${addr INTERFACEETH}/Adresse IP : \${addr $interfaceeth}/g" ~/.conky.cfg 
	echo "Remplacement de ${addr INTERFACEETH} par ${addr $interfaceeth} dans ~/.conky.cfg" >> $backgroundlogfile
fi
if grep "SALLEESU" ~/.conky.cfg > /dev/null; then
	sed -i "s/SALLEESU/$gm_esu/g" ~/.conky.cfg
	echo "Remplacement de SALLEESU par $gm_esu dans ~/.conky.cfg" >> $backgroundlogfile
fi
conky -c ~/.conky.cfg


######################################################################
#                            PARAM GSET                              #
######################################################################
echo "Lancement du gpo lecture fichier gset du groupe esu :" >> $backgroundlogfile
cp /tmp/netlogon/icones/$gm_esu/linux/gset/gset.sh /tmp
chmod +x /tmp/gset.sh
/tmp/gset.sh
rm -f /tmp/gset.sh
echo "Fin" >> $backgroundlogfile
exit 0
#
#
#