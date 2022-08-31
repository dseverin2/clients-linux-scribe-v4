if [ ! -e /opt/SweetHome3D-6.6/ ]; then
	sudo tar xvf /media/Serveur_Scribe/commun/logiciels/LINUX/SweetHome3D-6.6-linux-x64.tgz -C /opt
	sudo cp /opt/SweetHome3D-6.6/SweetHome3DIcon.png /usr/share/icons/
	sudo cp /media/Serveur_Scribe/commun/logiciels/LINUX/sweethome3d.desktop /usr/share/applications/
fi
