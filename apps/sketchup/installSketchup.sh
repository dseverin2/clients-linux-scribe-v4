#!/bin/sh
# Script original de Didier SEVERIN (11/09/22)
wget https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt update
sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
sudo apt-get update
sudo apt-get install --install-recommends wine-staging winehq-staging -y
echo "Mettre windows version 7 & dans bibliothèque riched20"
echo "Rajouter /DisableRubyAPI à la fin de la commande de lancement de sketchup"

#install sharedwine
./installSharedWine.sh


winecfg


# Not sur the above works, seems better when launching winetricks, default config then in settings selecting win7.
# Download from https://www.sketchup.com/fr/sketchup/2017/en/sketchupmake-2017-2-2555-90782-en-x64-exe
sudo -u $SUDO_USER wget http://www.rossum.fr/technocollege/telechargements/logiciels/SketchupMake2017frx64.exe
sudo -u $SUDO_USER wine sketchupmake-2017-2-2555-90782-en-x64-exe
