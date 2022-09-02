#!/bin/bash
# v1.1 - 24.02.21
# Didier SEVERIN
activinspire=activinspire_1804-2.21.69365-1-amd64.deb
activdriver=activdriver_5.18.19-0~Ubuntu~2004_amd64.deb
activtools=activtools_5.18.19-0~Ubuntu~2004_amd64.deb
activaid=activaid_2.0.1-0~Ubuntu~2004_amd64.deb
	
if [ ! -e /usr/local/bin/inspire ]; then
	cp -fr /media/Serveur_Scribe/commun/logiciels/apt/Promethean/ /tmp
	cd /tmp/Promethean

	# Installation de libssl
	apt install -y libssl-dev
	dpkg -i libssl*.deb

	# Installation des librairies utilisées au lancement d'ActivInspire
	sudo dpkg -i libicu60_60.2-3ubuntu3.1_amd64.deb
	apt install -y libicu60
	sudo apt-get install gsettings-ubuntu-schemas libjpeg62

	# Installation
	apt install -y libpcre16-3
	sudo dpkg -i activaid*.deb activdriver*.deb activtools*.deb activinspire*.deb
	apt install --fix-broken -y
	apt autoremove -y
	cd ~
	rm -f /tmp/Promethean/
fi

