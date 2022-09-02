#!/bin/sh

# Test Root
if [ $(id -u) -ne 0 ]; then                       
    echo "Vous devez être root pour lancer ce script" >&2
    exit 1
fi

# Installation des packets arduino
apt update
apt-get install -y arduino
sourcePath="/media/Serveur_Scribe/commun/logiciels/apt"


# Installation de mBlock 4.0.4 (après récupération du .deb)
apt-get -y install libgconf-2-4 
if [ ! -e "$sourcePath"/mBlock_4.0.4_amd64.deb ]; then
	wget -nc "$wgetparams" --no-check-certificate http://mblock.makeblock.com/mBlock4.0/mBlock_4.0.4_amd64.deb -o "$sourcePath"/mBlock_4.0.4_amd64.deb
fi
if [ ! -e "$sourcePath"/mLink-1.2.0-amd64.deb ]; then
	wget -nc "$wgetparams" --no-check-certificate https://dl.makeblock.com/mblock5/linux/mLink-1.2.0-amd64.deb -o "$sourcePath"/mLink-1.2.0-amd64.deb
fi
dpkg -i "$sourcePath"/mBlock_4.0.4_amd64.deb
dpkg -i "$sourcePath"/mLink-1.2.0-amd64.deb
apt install -fy

# Installation des librairies manquantes
unzip -o "$sourcePath"/mBlock.zip -d /opt/makeblock/mBlock
chmod 777 /opt/makeblock/mBlock/resources/web/tmp/project.sb2

#Installation des librairies pour arduino
cd /usr/share/arduino/lib || exit
if [ -e master.zip ]; then
	rm -f master.zip
fi
wget -nc https://github.com/Makeblock-official/Makeblock-Libraries/archive/master.zip
unzip -o master.zip
