if [ ! -e /etc/firefox/version91 ]; then
	sudo dpkg -i /media/Serveur_Scribe/commun/logiciels/LINUX/firefox-esr_91.9.0esr+build1-0ubuntu0.20.04.1_amd64.deb
	sudo dpkg -i /media/Serveur_Scribe/commun/logiciels/LINUX/firefox-esr-locale-fr_91.9.0esr+build1-0ubuntu0.20.04.1_amd64.deb
	echo "26.04.22" > /etc/firefox/version91
	sudo rm -f /usr/bin/firefox
	sudo ln -s /usr/bin/firefox-est /usr/bin/firefox
fi
