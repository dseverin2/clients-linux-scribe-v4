#!/bin/bash
# source https://romainhk.wordpress.com/2014/07/04/partager-une-meme-installation-playonlinux-avec-les-autres-utilisateurs/
# Script original de Didier SEVERIN (07/03/23)
if [ $UID -eq 0 ]; then
	echo "Lancez ce script sans sudo svp"
	exit 
fi 
echo 1/5 - RECUPERATION DES INSTALLATEURS
zenity --notification --text="1/5 - RECUPERATION DES INSTALLATEURS"
# Récupération du fichier executable et des bibliothèques windows nécessaires
sketchupexe=SketchupMake2017frx64.exe
sketchupggl=18qU9Ohn1ZCp43_QLsZmfzz3hGWeEUBT2
if [ ! -e ./$sketchupexe ]; then
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$sketchupggl' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$sketchupggl" -O ./$sketchupexe && sudo rm -rf /tmp/cookies.txt
	#sketchup 2017 ici https://aca.re/dseverin2/sketchup ou http://www.rossum.fr/technocollege/telechargements/logiciels/$sketchupexe 
fi

dotnetexe=NDP452-KB2901907-x86-x64-AllOS-ENU.exe
dotnetggl=17OE26kWrILHSEVlzd388i2BwW7e2xNWJ
if [ ! -e ./$sketchupexe ]; then
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$dotnetggl' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$dotnetggl" -O ./$dotnetexe && sudo rm -rf /tmp/cookies.txt
	#Microsoft .NET Framework ici https://www.microsoft.com/fr-FR/download/details.aspx?id=42642
fi

vc2015=vc_redist.x64.exe
vc2015ggl=1xe5hW0nrTgPCpoMJqXZOErSeoT0bmKRM
if [ ! -e ./$sketchupexe ]; then
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$vc2015ggl' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$vc2015ggl" -O ./$vc2015 && sudo rm -rf /tmp/cookies.txt
	#Visual C++ 2015 64 ici https://www.microsoft.com/fr-FR/download/details.aspx?id=48145
fi

# Téléchargement de wine
clear
echo 2/5 - INSTALLATION DE WINE 
zenity --notification --text="2/5 - INSTALLATION DE WINE"
sudo apt remove wine* wine64* -y
wget https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt update
sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
sudo apt-get update
sudo apt-get install --install-recommends wine-staging winehq-staging -y

clear
echo 3/5 - PARAMETRAGE DE WINE ET INSTALLATION DE SKETCHUP 
zenity --notification --text="3/5 - PARAMETRAGE DE WINE ET INSTALLATION DE SKETCHUP "
sudo apt install winetricks -y
winetricks dotnet45
wget -nc https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86.tar.xz
if [ ! -e /usr/share/wine/ ]; then sudo mkdir /usr/share/wine; fi
sudo tar xvf wine-gecko-2.47.3-x86.tar.xz -C /usr/share/wine/
sudo mv /usr/share/wine/wine-gecko-2.47.3-x86 /usr/share/wine/gecko
zenity --info --text="Dans la fenetre verifier que windows7 est selectionné et dans bibliothèque rajouter riched20"
winecfg
wine $dotnetexe
wine $vc2015
wine $sketchupexe

clear
echo 4/5 - DEFINITION DES RACCOURCIS ET DEPLACEMENT DE SKETCHUP-WINE VERS EMPLACEMENT COMMUN 
zenity --notification --text="4/5 - DEFINITION DES RACCOURCIS ET DEPLACEMENT DE SKETCHUP-WINE VERS EMPLACEMENT COMMUN"
sed -i 's/SketchUp.exe/SketchUp.exe \/DisableRubyAPI/g' ~/Bureau/SketchUp\ 2017.desktop
groupesalle=echo $(cat /etc/GM_ESU)
sed '/^Icon/d' ~/Bureau/SketchUp\ 2017.desktop
echo "Icon=/tmp/netlogon/icones/$groupesalle/icones/sketchup.png" >> ~/Bureau/SketchUp\ 2017.desktop
mkdir ~/.wine/shortcuts
cp ~/Bureau/SketchUp*.desktop ~/.wine/shortcuts/
rm -f ~/Bureau/Layout\ 2017.* ~/Bureau/Sketchup\ 2017.* ~/Bureau/Style\ Builder\ 2017.*

clear
echo 5/5 - PARAMETRAGE SKETCHUP SUR WINE POUR TOUS LES UTILISATEURS
zenity --notification --text="5/5 - PARAMETRAGE SKETCHUP SUR WINE POUR TOUS LES UTILISATEURS"
sudo mkdir /var/WINE
sudo mv ~/.wine/* /var/WINE/
sudo cp ./sketchup-shared.sh /usr/local/bin/
sudo chmod +x-w /usr/local/bin/sketchup-shared.sh
sudo chmod a+s /usr/local/bin/sketchup-shared.sh
