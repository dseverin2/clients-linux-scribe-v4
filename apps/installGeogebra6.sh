#!/bin/sh
# Script original de Didier SEVERIN (20/09/22)

# Les lignes ci-dessous ne fonctionnent plus au 20/09/2022
# wget -q -O - http://www.geogebra.net/linux/office@geogebra.org.gpg.key | sudo apt-key add -
# apt-add-repository -y 'deb http://www.geogebra.net/linux/ stable main'
# apt install geogebra-classic -y

# On récupère directement le fichier deb
sudo apt remove --purge geogebra
wget -q "$wgetparams" --no-check-certificate -np -l 1 -r -A amd64.deb https://www.geogebra.net/linux/pool/main/g/geogebra-classic/
sudo dpkg -i www.geogebra.net/linux/pool/main/g/geogebra-classic/geogebra-classic*amd64.deb || sudo apt-get --fix-broken install
