#!/bin/bash
# source https://romainhk.wordpress.com/2014/07/04/partager-une-meme-installation-playonlinux-avec-les-autres-utilisateurs/
# Script original de Didier SEVERIN (11/09/22)
if [ $UID -eq 0 ]; then
	echo "Lancez ce script sans sudo svp"
	exit 
fi 

# Récupération du fichier executable et des bibliothèques windows nécessaires
sketchupexe=SketchupMake2017frx64.exe
sketchupggl=18qU9Ohn1ZCp43_QLsZmfzz3hGWeEUBT2
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$sketchupggl' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$sketchupggl" -O ./$sketchupexe && sudo rm -rf /tmp/cookies.txt
#sketchup 2017 ici https://aca.re/dseverin2/sketchup ou http://www.rossum.fr/technocollege/telechargements/logiciels/$sketchupexe 

dotnetexe=NDP452-KB2901907-x86-x64-AllOS-ENU.exe
dotnetggl=17OE26kWrILHSEVlzd388i2BwW7e2xNWJ
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$dotnetggl' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$dotnetggl" -O ./$dotnetexe && sudo rm -rf /tmp/cookies.txt
#Microsoft .NET Framework ici https://www.microsoft.com/fr-FR/download/details.aspx?id=42642

vc2015=vc_redist.x64.exe
vc2015ggl=1xe5hW0nrTgPCpoMJqXZOErSeoT0bmKRM
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$vc2015ggl' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$vc2015ggl" -O ./$vc2015 && sudo rm -rf /tmp/cookies.txt
#Visual C++ 2015 64 ici https://www.microsoft.com/fr-FR/download/details.aspx?id=48145

# Téléchargement de wine 
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
zenity --info --text="Dans la fenetre verifier que windows7 est selectionné et dans bibliothèque rajouter riched20"

winecfg
wine $dotnetexe
wine $vc2015
wine $sketchupexe
#zenity --info --text="Modifier le lanceur Sketchup2017 du bureau et Rajouter /DisableRubyAPI à la fin de la commande"
sed -i 's/SketchUp.exe/SketchUp.exe \/DisableRubyAPI/g' ~/Bureau/SketchUp*.desktop
mkdir ~/.wine/shortcuts
cp ~/Bureau/SketchUp*.desktop ~/.wine/shortcuts/
sudo mkdir /var/WINE
sudo mv ~/.wine/* /var/WINE/
cp ./sketchup-shared.sh /usr/local/bin/
echo "%users ALL=NOPASSWD: /usr/local/bin/sketchup-shared.sh" | sudo tee -a /etc/sudoers.d/sketchup-shared
chmod +x-w /usr/local/bin/sketchup-shared.sh

if ! grep "/usr/local/bin/sketchup-shared.sh" /etc/profile >/dev/null; then
	echo '#!/bin/sh
bash -c "sudo /usr/local/bin/sketchup-shared.sh $(whoami) > ~/.sketchup-shared.log 2>&1"' | sudo tee -a /etc/profile
fi
