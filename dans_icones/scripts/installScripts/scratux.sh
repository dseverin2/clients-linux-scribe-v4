# scratux
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
#sudo echo "deb https://dl.bintray.com/scratux/stable bionic main" > /etc/apt/sources.list.d/scratux.list
#sudo apt-get update
#sudo apt-get install scratux
if [ ! -e /usr/bin/scratux ]; then
	scratuxinstallfile="/media/Serveur_Scribe/commun/logiciels/apt/scratux_1.4.1_amd64.deb"
	if [ ! -e $scratuxinstallfile ]; then
		wget -nc https://github.com/scratux/scratux/releases/download/1.4.1/scratux_1.4.1_amd64.deb -O /media/Serveur_Scribe/commun/logiciels/apt/scratux_1.4.1_amd64.deb
	fi
	sudo dpkg -i $scratuxinstallfile
fi
