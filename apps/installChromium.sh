#!/bin/sh
echo "install chromium"
source $baserep/config.cfg
sudo apt remove chromium-browser -y
sudo snap remove chromium

sudo -E add-apt-repository ppa:saiarcot895/chromium-beta -y
sudo apt install chromium-browser --install-suggests -y

if [ -e /usr/bin/chromium-browser ]; then
	sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
	sudo ln -s /etc/chromium-browser /etc/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
	sudo ln -s /etc/chromium /etc/chromium-browser
fi

sudo cp -f $baserep/dans_icones/scripts/chromium/master_preferences /etc/chromium-browser/master_preferences
sudo ln -s /etc/chromium-browser/master_preferences /etc/chromium/master_preferences
