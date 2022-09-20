#!/bin/sh

# Test Root
if [ $(id -u) -ne 0 ]; then
	echo "Vous devez être root pour lancer ce script" >&2
    exit 1
fi

# Installation des packets arduino
apt update
apt-get install -y arduino

# Installation de mBlock 4.0.4 (après récupération du .deb)
apt-get -y install libgconf-2-4 
wget -nc -q "$wgetparams" --no-check-certificate http://mblock.makeblock.com/mBlock4.0/mBlock_4.0.4_amd64.deb
wget -nc -q "$wgetparams" --no-check-certificate https://dl.makeblock.com/mblock5/linux/mLink-1.2.0-amd64.deb
dpkg -i ./mBlock_4.0.4_amd64.deb
dpkg -i ./mLink-1.2.0-amd64.deb
apt install -fy

# Installation des librairies manquantes
unzip -o $baserep/apps/mBlock.zip -d /opt/makeblock/mBlock
chmod 777 /opt/makeblock/mBlock/resources/web/tmp/project.sb2

#Installation des librairies pour arduino
wget -nc -q "$wgetparams" --no-check-certificate https://github.com/Makeblock-official/Makeblock-Libraries/archive/master.zip -O /usr/share/arduino/lib/master.zip
unzip -o /usr/share/arduino/lib/master.zip -d /usr/share/arduino/lib/
