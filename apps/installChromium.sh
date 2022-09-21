#!/bin/sh
echo "install chromium"
sudo apt remove chromium-beta -y
sudo snap remove chromium
export HTTP_PROXY=http://$scribeuserapt:$scribepass@$proxy_def_ip:$proxy_def_port
export HTTPS_PROXY=http://$scribeuserapt:$scribepass@$proxy_def_ip:$proxy_def_port
export http_proxy=http://$scribeuserapt:$scribepass@$proxy_def_ip:$proxy_def_port
export https_proxy=http://$scribeuserapt:$scribepass@$proxy_def_ip:$proxy_def_port

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
