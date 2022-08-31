#!/bin/bash
if [ -e /etc/apt/preferences.d/nosnap.pref ]; then
	sudo rm -fr /etc/apt/preferences.d/nosnap.pref
fi
sudo apt update
sudo apt install snapd
sudo snap set system proxy.http="http://apt.esubuntu:Zaf1r4poRSrt4dkkfs2d12z5@172.18.248.1:3129/"
sudo snap set system proxy.https="http://apt.esubuntu:Zaf1r4poRSrt4dkkfs2d12z5@172.18.248.1:3129/"
if [ ! -e /usr/bin/pymecavideo ]; then
	sudo apt install python-mecavideo -y
fi
if [ ! -e /usr/bin/gnuplot ]; then
	sudo apt install gnuplot -y
fi
