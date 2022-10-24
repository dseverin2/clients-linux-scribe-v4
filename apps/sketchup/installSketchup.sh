#!/bin/sh
# source https://romainhk.wordpress.com/2014/07/04/partager-une-meme-installation-playonlinux-avec-les-autres-utilisateurs/
# Script original de Didier SEVERIN (11/09/22)

# Récupération du fichier executable et des bibliothèques windows nécessaires
sketchupexe=SketchupMake2017frx64.exe
zenity --info --text="Télécharger sketchup 2017 ici https://aca.re/dseverin2/sketchup ou http://www.rossum.fr/technocollege/telechargements/logiciels/$sketchupexe et placez-le dans ce répertoire (ne pas fermer cette fenêtre avant que ce soit fait)"
mv ~/Téléchargements/$sketchupexe .

dotnetexe=NDP452-KB2901907-x86-x64-AllOS-ENU.exe
zenity --info --text="Télécharger Microsoft .NET Framework ici https://www.microsoft.com/fr-FR/download/details.aspx?id=42642 et placez-le dans ce répertoire (ne pas fermer cette fenêtre avant que ce soit fait)"
mv ~/Téléchargements/$dotnetexe .

vc2015=vc_redist.x64.exe
zenity --info --text="Télécharger Visual C++ 2015 64 ici https://www.microsoft.com/fr-FR/download/details.aspx?id=48145 et placez-le dans ce répertoire (ne pas fermer cette fenêtre avant que ce soit fait)"
mv ~/Téléchargements/$vc2015 .

# Téléchargement de wine 
wget https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt update
sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
sudo apt-get update
sudo apt-get install --install-recommends wine-staging winehq-staging -y
zenity --info text="Dans la fenetre verifier que windows7 est selectionné et dans bibliothèque rajouter riched20"

winecfg
wine $dotnetexe
wine $vc2015
wine $sketchupexe
zenity --info text="Modifier le lanceur Sketchup2017 du bureau et Rajouter /DisableRubyAPI à la fin de la commande"
mkdir ~/.wine/shortcuts
cp ~/Bureau/SketchUp*.desktop ~/.wine/shortcuts/
cp ./sketchup-shared.sh /usr/local/bin/
echo "%users ALL=NOPASSWD: /usr/local/bin/sketchup-shared.sh" > /etc/sudoers.d/sketchup-shared
chmod +x-w /usr/local/bin/sketchup-shared

if ! grep "/usr/local/bin/sketchup-shared" /etc/profile >/dev/null; then
	echo '#!/bin/sh
bash -c "sudo /usr/local/bin/sketchup-shared.sh $(whoami) > ~/.sketchup-shared.log 2>&1"' >> /etc/profile
fi