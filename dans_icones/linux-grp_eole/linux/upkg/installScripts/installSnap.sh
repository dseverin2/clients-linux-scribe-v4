#!/bin/bash
if [ -e /etc/apt/preferences.d/nosnap.pref ]; then
	sudo rm -fr /etc/apt/preferences.d/nosnap.pref
fi
sudo apt update
sudo apt install snapd
if [ ! -e /snap/bin/hello-world ]; then
	sudo snap install hello-world
fi
if [ ! -e /usr/bin/pymecavideo ]; then
	sudo apt install python-mecavideo -y
fi
if [ ! -e /usr/bin/gnuplot ]; then
	sudo apt install gnuplot -y
fi
