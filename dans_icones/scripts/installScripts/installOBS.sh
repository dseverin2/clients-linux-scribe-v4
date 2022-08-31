#!/bin/bash
if [ ! -e /usr/bin/obs ]; then
	sudo apt remove libobs0 obs-plugins obs-studio -y
	sudo apt-get install v4l2loopback-dkms libfdk-aac1 -y
	sudo modprobe v4l2loopback card_label=“Caméra Virtuelle OBS” 
	sudo gdebi -n /media/Serveur_Scribe/commun/logiciels/LINUX/obs-studio_27.0.1-0obsproject1~focal_amd64.deb 
fi


