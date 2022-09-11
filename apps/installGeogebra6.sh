#!/bin/sh
# Script original de Didier SEVERIN (13/05/20)
wget -q -O - http://www.geogebra.net/linux/office@geogebra.org.gpg.key | sudo apt-key add -
apt-add-repository -u 'deb http://www.geogebra.net/linux/ stable main'
apt install geogebra-classic
