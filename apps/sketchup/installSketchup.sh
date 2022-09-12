#!/bin/sh
# source https://romainhk.wordpress.com/2014/07/04/partager-une-meme-installation-playonlinux-avec-les-autres-utilisateurs/
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
rm -rf /var/POL
cp -R ~/.PlayOnLinux /var/POL
echo "%users ALL=NOPASSWD: /usr/local/bin/sketchup.sh" | sudo tee /etc/sudoers.d/sketchup
sudo chmod +x-w /usr/local/bin/sketchup.sh
# Modif de sraccourcis

# Param install playonlinux sketchup2017
# ajouter vcrun 2013 et 2015 + ndp4.5.2

#!/bin/bash
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
export WINEPREFIX="$(eval echo ~$USER)/.PlayOnLinux//wineprefix/Office2010"
export WINEDEBUG="-all"
cd "$WINEPREFIX/drive_c/./Program Files/Microsoft Office/Office14"
POL_Wine "WINWORD.EXE"  "$@"
#Raccourci bureau
echo "[Desktop Entry]
Encoding=UTF-8
Name=Sketchup 2017
Comment=PlayOnLinux
Type=Application
Exec=/usr/share/playonlinux/playonlinux --run "Microsoft Word 2010" %F
Icon=/var/POL/icones/full_size/Microsoft Word 2010
Name[fr_FR]=Word 2010
StartupWMClass=Word 2010.exe
Categories=" > sketchup.desktop
chmod a+x sketchup.desktop
echo "bash -c \"sudo /usr/local/bin/office.sh $(whoami) > ~/.office.log 2>&1\"" >> /etc/profile

winecfg


# Not sur the above works, seems better when launching winetricks, default config then in settings selecting win7.
# Download from https://www.sketchup.com/fr/sketchup/2017/en/sketchupmake-2017-2-2555-90782-en-x64-exe
sudo -u $SUDO_USER wget http://www.rossum.fr/technocollege/telechargements/logiciels/SketchupMake2017frx64.exe
sudo -u $SUDO_USER wine sketchupmake-2017-2-2555-90782-en-x64-exe
