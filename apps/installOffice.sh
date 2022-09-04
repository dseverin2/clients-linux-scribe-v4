#!/bin/bash
# Script original de Didier SEVERIN (04/09/22)

#INSTALLATION DES POLICES
wget -nc --no-check-certificate http://download.tuxfamily.org/polyglotte/archives/msfonts-config2.zip -P ./tmp_dl/
unzip -o ./tmp_dl/msfonts-config2.zip -d /etc/fonts/
apt-get install gsfonts gsfonts-other gsfonts-x11 ttf-mscorefonts-installer t1-xfree86-nonfree fonts-alee ttf-ancient-fonts fonts-arabeyes fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-atarismall fonts-dustin fonts-f500 fonts-sil-gentium ttf-georgewilliams ttf-isabella fonts-larabie-deco fonts-larabie-straight fonts-larabie-uncommon ttf-sjfonts ttf-staypuft ttf-summersby fonts-ubuntu-title ttf-xfree86-nonfree xfonts-intl-european xfonts-jmk xfonts-terminus fonts-liberation ubuntu-restricted-extras -y

#INSTALLATION DE WPS Office
if $WPSOffice; then
	writelog "------WPS Office + French"
	unzip -o WPS\ Office/winfonts.zip -d /usr/share/fonts/winfonts/
	rm -fr msfonts-config2.zip
	build="11664"
	version="11.1.0."$build

	# Logiciel
	wget -nc --no-check-certificate http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/$build/wps-office_$version.XA_amd64.deb
	dpkg -i wps-office_$version.XA_amd64.deb
	# Dictionnaire FR
	apt install p7zip p7zip-full hunspell-fr -y
	wget -nc --no-check-certificate http://grammalecte.net/download/fr/hunspell-french-dictionaries-v7.0.zip
	unzip hunspell*.zip -d ./hunspell/
	mkdir /opt/kingsoft/wps-office/office6/dicts/spellcheck/fr_FR/
	printf "[Dictionary]\nDisplayName=Français\nDisplayName[zh_CN]=Français\nDisplayName[en_US]=Français" | tee /opt/kingsoft/wps-office/office6/dicts/spellcheck/fr_FR/dict.conf
	printf "DisplayName[zh_TW]=Français\nDisplayName[zh_HK]=Français\nDisplayName[zh_MO]=Français\nDisplayName[zh_Hant_CN]=Français\n" | tee -a /opt/kingsoft/wps-office/office6/dicts/spellcheck/fr_FR/dict.conf
	mv -fr ./hunspell/*toutesvariantes.aff /opt/kingsoft/wps-office/office6/dicts/spellcheck/fr_FR/main.aff
	# Interface FR
	wget -nc --no-check-certificate https://www.linuxtricks.fr/upload/wps-fr.tar.xz
	tar xvf wps-fr.tar.xz
	tar xvf wps-fr.tar -C /opt/kingsoft/wps-office/office6/mui/
	cp -fr /opt/kingsoft/wps-office/office6/mui/fr_FR/* /opt/kingsoft/wps-office/office6/mui/ug_CN/
	cp -fr /opt/kingsoft/wps-office/office6/mui/fr_FR/* /opt/kingsoft/wps-office/office6/mui/en_US/
	rm -f wps-office_$version.XA_amd64.deb wps-fr* hunspell*
fi

# Extension CMathsOOo
CMinstallfile="CmathOOo.oxt"	
if [ ! -e $CMinstallfile ]; then
	wget -nc --no-check-certificate http://cdeval.free.fr/CmathOOoUpdate/$CMinstallfile -P ./tmp_dl/
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
wget -nc --no-check-certificate http://cdeval.free.fr/IMG/ttf/Cmath.ttf -P /usr/share/fonts
wget -nc --no-check-certificate http://cdeval.free.fr/IMG/ttf/cmathscr.ttf -P /usr/share/fonts
wget -nc --no-check-certificate http://cdeval.free.fr/IMG/ttf/cmathcal.ttf -P /usr/share/fonts
chmod a+r /usr/share/fonts/*
fc-cache -f -v
rm -fr ./*.oxt
sudo apt-get clean -y
sudo apt-get autoremove -y
