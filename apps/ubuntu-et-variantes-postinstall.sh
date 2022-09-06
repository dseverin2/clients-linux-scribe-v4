#!/bin/bash
# version 2.4 (30/10/20)
# Ce script sert à installer des logiciels supplémentaires utiles pour les collèges & lyçées
# Ce script est utilisable pour Ubuntu et variantes en 14.04, 16.04, 18.04, 20.04

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]; then
	echo "Il faut etre root pour executer ce script. ==> sudo "
	exit 
fi 

# Verification de la présence des fichiers contenant les fonctions et variables communes
if [ -e ./esub_functions.sh ]; then
	source ./esub_functions.sh
elif [ -e ../esub_functions.sh ]; then
	source ../esub_functions.sh
else
	echo "Fichier esub_functions.sh absent ! Interruption de l'installation."
	exit
fi

thislog=/home/$localadmin/integrdom-basicpostinstall.log
templog=""
if [ "$appslogfile" != "" ]; then
	templog=$appslogfile
fi
appslogfile=$thislog
initlog
	
# Récupération de la version d'ubuntu
getversion >>2 $appslogfile

baseapps=$(dirname $(realpath $0))

# désactiver mode intéractif pour automatiser l'installation de wireshark
export DEBIAN_FRONTEND="noninteractive"

writelog "Ajout dépot partenaire"
apt install software-properties-common -y  >>2 $appslogfile
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5 >>2 $appslogfile

writelog "Vérification que le système est à jour"
apt-get update ; apt-get -y full-upgrade >>2 $appslogfile; apt-get -y dist-upgrade >>2 $appslogfile

writelog "Installation de gdebi"
apt install gdebi-core -y >>2 $appslogfile

writelog "Installation de geany"
apt install geany -y >>2 $appslogfile
apt remove mintwelcome -y >>2 $appslogfile

writelog "Installation des logiciels de TBI"
if $activinspire; then
	writelog "---ActivInspire"
	source $baseapps"/TBI/installActivInspire.sh" >>2 $appslogfile
fi
if $ebeam; then
	writelog "---Ebeam"
	source $baseapps"/TBI/installEbeam.sh" >>2 $appslogfile
fi

#########################################
# Paquets uniquement pour Trusty (14.04)
#########################################
if [ "$version" = "trusty" ] ; then
	writelog "INITBLOC" "Trusty 14.04" "---idle, gstreamer, celestia"
	apt-get install -y idle-python3.4 gstreamer0.10-plugins-ugly celestia >>2 $appslogfile

	if $LibreOffice; then
		writelog "---Backportage LibreOffice"
		add-apt-repository -y ppa:libreoffice/ppa  >>2 $appslogfile; apt-get update ; apt-get -y upgrade
	fi

	writelog "---Google Earth"
	apt-get install -y libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386 >>2 $appslogfile
	wget -nc -q "$wgetparams"  https://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb --no-check-certificate >>2 $appslogfile; 
	dpkg -i google-earth-stable_current_i386.deb  >>2 $appslogfile; apt-get -fy install >>2 $appslogfile
	writelog "ENDBLOC"
fi

#########################################
# Paquets uniquement pour Xenial (16.04)
#########################################
if [ "$version" = "xenial" ] ; then
	if $LibreOffice; then
		writelog "INITBLOC" "Xenial 16.04" "---breeze (Libreoffice), idle, x265"
		apt install -y libreoffice-style-breeze  >>2 $appslogfile
		writelog "---Backportage LibreOffice"
		add-apt-repository -y ppa:libreoffice/ppa  >>2 $appslogfile; apt update ; apt upgrade -y
	fi
	
	apt-install idle-python3.5 x265  >>2 $appslogfile;

	writelog "---Google Earth"
	wget -nc -q "$wgetparams" --no-check-certificate https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb 
	wget -nc "$wgetparams" --no-check-certificate http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-core_4.1+Debian13+nmu1_amd64.deb
	wget -nc "$wgetparams" --no-check-certificate http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-security_4.1+Debian13+nmu1_amd64.deb 
	dpkg -i lsb*.deb ; dpkg -i google-earth*.deb ; apt install -fy

	writelog "---Celestia"
	wget -nc "$wgetparams" --no-check-certificate https://gitlab.com/simbd/Scripts_Ubuntu/-/blob/7925144bf30ed4c353b9676521d591dc35c97dde/Celestia_pour_Bionic.sh
	cp $second_dir/Celestia_pour_Bionic.sh .
	chmod +x Celestia_pour_Bionic.sh ; ./Celestia_pour_Bionic.sh ; rm Celestia*
	writelog "ENDBLOC"
fi

#########################################
# Paquet uniquement pour Bionic (18.04)
#########################################
if [ "$version" = "bionic" ] ; then
	writelog "INITBLOC" "Bionic 18.04" "---idle, x265"
	apt-get install -y idle-python3.6 x265

	writelog "---Google Earth Pro x64" 
	wget -nc "$wgetparams" -q --no-check-certificate https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb ; dpkg -i google-earth-pro-stable_current_amd64.deb ; apt install -fy
	rm /etc/apt/sources.list.d/google-earth* ; rm google-earth-pro* #dépot google retiré volontairement

	writelog "---Celestia"
	wget -nc "$wgetparams" --no-check-certificate https://gitlab.com/simbd/Scripts_Ubuntu/-/blob/7925144bf30ed4c353b9676521d591dc35c97dde/Celestia_pour_Bionic.sh
	cp $second_dir/Celestia_pour_Bionic.sh .
	chmod +x Celestia_pour_Bionic.sh ; ./Celestia_pour_Bionic.sh ; rm Celestia*

	writelog "---Pilote imprimante openprinting"
	apt-get install -y openprinting-ppds
	writelog "ENDBLOC"
fi

#########################################
# Paquet uniquement pour Focal (20.04)
#########################################
if [ "$version" = "focal" ] ; then
	writelog "INITBLOC" "Focal 20.04" "---idle, x265"
	apt-get install -y idle-python3.6 x265 >>2 $appslogfile

	writelog "---Google Earth Pro x64" 
	wget -nc "$wgetparams" -q --no-check-certificate https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb  >>2 $appslogfile; dpkg -i google-earth-pro-stable_current_amd64.deb  >>2 $appslogfile; apt install -fy >>2 $appslogfile
	rm /etc/apt/sources.list.d/google-earth* ; #dépot google retiré volontairement

	writelog "---Celestia"
	cp $second_dir/Celestia_pour_focal.sh . >>2 $appslogfile
	chmod +x Celestia_pour_focal.sh ; ./Celestia_pour_focal.sh  >>2 $appslogfile; rm Celestia*

	writelog "---Pilote imprimante openprinting"
	apt-get install -y openprinting-ppds >>2 $appslogfile
	
	writelog "ENDBLOC"
fi

#=======================================================================================================#

if [ "$version" != "bionic" ] && [ "$version" != "focal" ] && [ "$version" != "jammy" ] ; then  # Installation spécifique pour 14.04 ou 16.04
	writelog "Drivers imprimantes pour les version < 18.04"
	wget -nc "$wgetparams" --no-check-certificate http://www.openprinting.org/download/printdriver/debian/dists/lsb3.2/contrib/binary-amd64/openprinting-gutenprint_5.2.7-1lsb3.2_amd64.deb
	dpkg -i openprinting-gutenprint_5.2.7-1lsb3.2_amd64.deb ; apt-get -fy install ; rm openprinting-gutenprint*

	writelog "Gdevelop (PPA pas encore actif pour la 18.04)"
	add-apt-repository -y ppa:florian-rival/gdevelop
	apt-get update ; apt-get install -y gdevelop
fi

writelog "drivers pour les scanners les plus courants"
apt-get install -y sane >>2 $appslogfile

writelog "Police d'écriture de Microsoft"
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt-get install -y ttf-mscorefonts-installer  >>2 $appslogfile;

writelog "INITBLOC" "[ Bureautique ]"
apt-get install -y freeplane scribus gnote xournal cups-pdf okular >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Web ]"
apt-get install -y default-jre adobe-flashplugin ; #permet d'avoir flash en même temps pour firefox et chromium >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Video / Audio ]"
apt-get install -y imagination openshot audacity vlc x264 ffmpeg2theora flac vorbis-tools lame oggvideotools mplayer ogmrip goobox >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Graphisme / Photo ]"
apt-get install -y blender sweethome3d gimp pinta inkscape gthumb mypaint hugin shutter >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Système ]"
apt-get install -y gparted vim pyrenamer rar unrar htop diodon p7zip-full gdebi >>2 $appslogfile
writelog "ENDBLOC"

writelog "Wireshark"
debconf-set-selections <<< 'wireshark-common/install-setuid boolean true'
apt-get install -y wireshark  >>2 $appslogfile
sed -i -e "s/,dialout/,dialout,wireshark/g" /etc/security/group.conf

writelog "INITBLOC" "[ Mathématiques ]"
apt-get install -y algobox carmetal scilab geophar >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Sciences ]"
apt-get install -y stellarium avogadro python-mecavideo gnuplot -y >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Programmation ]"
apt-get install -y ghex geany imagemagick gcolor2 >>2 $appslogfile
apt-get install -y python3-pil.imagetk python3-pil traceroute python3-tk #python3-sympy >>2 $appslogfile
flatpak install flathub edu.mit.Scratch -y >>2 $appslogfile
writelog "ENDBLOC"

writelog "INITBLOC" "[ Serveur ]"
apt-get install -y openssh-server openssh-client >>2 $appslogfile
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add - >>2 $appslogfile
echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list >>2 $appslogfile
apt update
apt install anydesk -y >>2 $appslogfile

writelog "ENDBLOC"


### Supplément de logiciel proposé dans la section wpkg du forum de la dane en version linux (pour Ubuntu 18.04)
### cf : https://forum-dane.ac-lyon.fr/forum/viewforum.php?f=44
if [ "$version" = "bionic" ] || [ "$version" = "focal" ] || [ "$version" = "jammy" ] ; then
	writelog "INITBLOC" "Suppléments de logiciels pour Bionic et Focal"
	writelog "---Openshot-qt, Gshutdown, X-Cas, Planner, extension ooohg, winff, optgeo, ghostscript"
	apt-get install -y openshot-qt gshutdown xcas planner ooohg winff winff-qt optgeo ghostscript  >>2 $appslogfile
	
	writelog "---GanttProject"
	apt-get install -y openjdk-8-jre oenjdk-11-jre java-11-amazon-corretto-jdk bellsoft-java11-runtime >>2 $appslogfile
	wget -nc "$wgetparams" --no-check-certificate https://dl.ganttproject.biz/ganttproject-2.8.11/ganttproject_2.8.11-r2396-1_all.deb >>2 $appslogfile
	dpkg -i ganttproject*  >>2 $appslogfile; apt install -fy
	
	writelog "---mBlock"
	source $baseapps"/installmBlock.sh" >>2 $appslogfile
	
	writelog "---Xia (alias ImageActive)"
	wget -nc "$wgetparams" --no-check-certificate https://xia.funraiders.org/download/xia-3-inkscape.deb >>2 $appslogfile
	sudo dpkg -i xia-3-inkscape.deb >>2 $appslogfile
	apt install --fix-broken -y >>2 $appslogfile
	
	writelog "---Marble (avec le moins de dépendance KDE possible)"
	apt install --no-install-recommends marble -y >>2 $appslogfile
	
	writelog "---ScienceEngineering"
	apt-get install -y science-engineering >>2 $appslogfile
	
	writelog "---BlueGriffon"
	installfilename=bluegriffon-3.1.Ubuntu18.04-x86_64.deb
	wget -nc "$wgetparams" --no-check-certificate http://bluegriffon.org/freshmeat/3.1/$installfilename  >>2 $appslogfile && dpkg -i bluegriffon*.deb  >>2 $appslogfile; apt install -fy >>2 $appslogfile
	
	writelog "---SCRIPTS SUPPLEMENTAIRES"
	if [ -e $second_dir/installGeogebra6.sh ]; then
		scriptpath=$second_dir/
	elif [ -e ./installGeogebra6.sh ]; then
		scriptpath=./
	else
		scriptpath=""
		writelog "------ SCRIPTS ABSENTS"
	fi
	if [ "$scriptpath" != "" ]; then
		writelog "------Geogebra Classic"
		source "$scriptpath"installGeogebra6.sh >>2 $appslogfile
		
		# Suites bureautiques
		source "$scriptpath"installOffice.sh >>2 $appslogfile
		
		
		if $Veyon; then
			writelog "------Veyon"
			source "$scriptpath"installVeyon.sh >>2 $appslogfile
		fi
		
		writelog "------Openboard"
		source "$scriptpath"installOpenBoard.sh >>2 $appslogfile
	fi
	writelog "ENDBLOC"

	apt install --fix-broken -y  >>2 $appslogfile
fi

#=======================================================================================================#
# Installation spécifique suivant l'environnement de bureau

################################
# Concerne Ubuntu / Gnome
################################
if [ "$(command -v gnome-shell)" = "/usr/bin/gnome-shell" ] ; then  # si GS install
	writelog "[ Paquet AddOns ] de Gnome Shell"
	apt install -y ubuntu-restricted-extras ubuntu-restricted-addons gnome-tweak-tool >>2 $appslogfile
fi

################################
# Concerne Ubuntu / Unity
################################
if [ "$(command -v unity)" = "/usr/bin/unity" ] ; then  # si Ubuntu/Unity alors :
	writelog "[ Paquet AddOns ] d\'Unity"
	apt-get install -y ubuntu-restricted-extras ubuntu-restricted-addons unity-tweak-tool >>2 $appslogfile
	apt-get install -y nautilus-image-converter nautilus-script-audio-convert >>2 $appslogfile
fi

################################
# Concerne Xubuntu / XFCE
################################
if [ "$(command -v xfwm4)" = "/usr/bin/xfwm4" ] ; then # si Xubuntu/Xfce alors :
	writelog "[ Paquet AddOns ] de XFCE"
	apt-get install -y xubuntu-restricted-extras xubuntu-restricted-addons xfce4-goodies xfwm4-themes >>2 $appslogfile

	writelog "Customisation XFCE"
	if [ "$version" = "trusty" ] || [ "$version" = "xenial" ] ; then #ajout ppa pour 14.04 et 16.04 (pas nécessaire pour la 18.04)
		add-apt-repository -y ppa:docky-core/stable ; apt-get update   
	fi
	apt-get install -y plank  >>2 $appslogfile
fi

################################
# Concerne Ubuntu Mate
################################
if [ "$(command -v caja)" = "/usr/bin/caja" ] ; then # si Ubuntu Mate 
	writelog "Paramétrage de Caja (Ubuntu Mate)"
	apt-get install -y ubuntu-restricted-extras mate-desktop-environment-extras >>2 $appslogfile
	apt-get -y purge ubuntu-mate-welcome >>2 $appslogfile
fi

################################
# Concerne Lubuntu / LXDE
################################
if [ "$(command -v pcmanfm)" = "/usr/bin/pcmanfm" ] ; then  # si Lubuntu / Lxde alors :
	writelog "Paramétrage pcmanfm (LXDE)"
	apt-get install -y lubuntu-restricted-extras lubuntu-restricted-addons >>2 $appslogfile
fi


writelog "Lecture DVD"

# Lecture DVD sur Ubuntu 16.04 et supérieur ## répondre oui aux question posés...
if [ "$version" = "trusty" ]; then
	apt install -y libdvdread4 && bash /usr/share/doc/libdvdread4/install-css.sh 2>> $appslogfile
fi

if [ "$version" = "xenial" ] || [ "$version" = "bionic" ] || [ "$version" = "focal" ] || [ "$version" = "jammy" ]; then #lecture dvd pour 16.04 ou 18.04
	apt install -y libdvd-pkg >>2 $appslogfile
	dpkg-reconfigure libdvd-pkg >>2 $appslogfile
fi

writelog "Nettoyage de la station"
apt-get update ; apt-get -fy install  >>2 $appslogfile; apt-get -y autoremove --purge  >>2 $appslogfile; apt-get -y clean  >>2 $appslogfile;
clear

appslogfile=$templog
writelog "Le script de postinstall a terminé son travail"
