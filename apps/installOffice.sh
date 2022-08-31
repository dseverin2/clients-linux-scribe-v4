#!/bin/bash
# Script original de Didier SEVERIN (09/07/22)

#INSTALLATION DES POLICES
wget -nc http://download.tuxfamily.org/polyglotte/archives/msfonts-config2.zip -P ./tmp_dl/
unzip -o ./tmp_dl/msfonts-config2.zip -d /etc/fonts/
apt-get install gsfonts gsfonts-other gsfonts-x11 ttf-mscorefonts-installer t1-xfree86-nonfree fonts-alee ttf-ancient-fonts fonts-arabeyes fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-atarismall fonts-dustin fonts-f500 fonts-sil-gentium ttf-georgewilliams ttf-isabella fonts-larabie-deco fonts-larabie-straight fonts-larabie-uncommon ttf-sjfonts ttf-staypuft ttf-summersby fonts-ubuntu-title ttf-xfree86-nonfree xfonts-intl-european xfonts-jmk xfonts-terminus fonts-liberation ubuntu-restricted-extras -y

# Extension CMathsOOo
CMinstallfile="CmathOOo.oxt"	
if [ ! -e $CMinstallfile ]; then
	wget -nc http://cdeval.free.fr/CmathOOoUpdate/$CMinstallfile -P ./tmp_dl/
	mv ./tmp_dl/$CMinstallfile ./tmp_dl/CmathOOo.zip
	unzip ./tmp_dl/CmathOOo.zip -d ./tmp_dl/CmathOOo/
	rm -f ./tmp_dl/CmathOOo.zip
	description_original="./tmp_dl/CmathOOo/description.xml"
	description_compile="./tmp_dl/description.xml"
	echo "Retrait de la confirmation d'installation de CmathOOO.oxt"
	# Comptage du nombre de ligne dans le fichier d'extension original
	nombre_lignes_description_original=$(wc -l $description_original | awk '{print $1}')

	# Copie du début du description original dans le description compilé
	derniere_ligne_debut_description=$(($(echo $(grep -n "<registration>" $description_original) | cut -d ":" -f 1)-1))
	head -$derniere_ligne_debut_description $description_original > $description_compile

	# Copie de la fin du description original dans le description compilé
	premiere_ligne_fin_description=$(echo $(grep -n "</registration>" $description_original) | cut -d ":" -f 1)
	nombre_lignes_avant_fin=$(($nombre_lignes_description_original-$premiere_ligne_fin_description))
	tail -$nombre_lignes_avant_fin $description_original >> $description_compile

	# Reconstitution du fichier oxt
	mv $description_compile $description_original
	zip -r ./tmp_dl/CmathOOo.zip ./tmp_dl/CmathOOo
	mv ./tmp_dl/CmathOOo.zip ./tmp_dl/$CMinstallfile
fi

# Extension TexMaths
if [ ! -e ./tmp_dl/TexMaths-0-v2.49.oxt ]; then
	wget -nc https://extensions.libreoffice.org/assets/downloads/1236/TexMaths-0-v2.49.oxt -P ./tmp_dl/
fi

apt install libreoffice libreoffice-help-fr libreoffice-l10n-fr libreoffice-pdfimport -y
unopkgpath="/usr/bin"

$unopkgpath/unopkg add --shared ./tmp_dl/CmathOOo.oxt ./tmp_dl/TexMaths*.oxt
wget -nc http://cdeval.free.fr/IMG/ttf/Cmath.ttf -P /usr/share/fonts
wget -nc http://cdeval.free.fr/IMG/ttf/cmathscr.ttf -P /usr/share/fonts
wget -nc http://cdeval.free.fr/IMG/ttf/cmathcal.ttf -P /usr/share/fonts
chmod a+r /usr/share/fonts/*
fc-cache -f -v
rm -fr ./*.oxt
sudo apt-get clean -y
sudo apt-get autoremove -y
