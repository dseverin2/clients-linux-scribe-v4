#!/bin/bash
# Script original de Didier SEVERIN (17/09/20)
echo "EBEAM : installation des dépendances"
apt-get install libusb-dev yasm libvpx. Libx264. kazam onboard libboost-all-dev libboost-thread-dev -y

echo "EBEAM : téléchargement et extraction de l\'archive"
wget -nc https://speechi-support.speechi.net/EBEAM/eBeam-Interactive_3.6_ubuntu.tar.gz
tar xvf eBeam-Interactive_3.6_ubuntu.tar.gz
rm -fr eBeam-Interactive_3.6_ubuntu.tar.gz README.txt

echo "EBEAM : installation du paquet eBeam-Interact_3"
dpkg -i eBeam-Interact_3.6.0.deb
rm -fr eBeam-Interact_3.6.0.deb

echo "EBEAM : Fin de l'installation"
