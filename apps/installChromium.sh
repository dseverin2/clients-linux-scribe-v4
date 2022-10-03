#!/bin/sh
echo "---Installation de chromium"
echo "---Installation de chromium---" >> $logfile
sudo apt remove chromium-browser -y
sudo snap remove chromium

for i in http_proxy https_proxy HTTPS_PROXY HTTP_PROXY; do
	export $i=http://$scribeuserapt:$scribepass@$proxy_def_ip:$proxy_def_port 2>> $logfile;
	echo export $i=http://$scribeuserapt:$scribepass@$proxy_def_ip:$proxy_def_port >> $logfile;
done

sudo -E add-apt-repository ppa:saiarcot895/chromium-beta -y
sudo apt install chromium-browser --install-suggests -y

if [ -e /usr/bin/chromium-browser ]; then
	sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
	sudo ln -s /etc/chromium-browser /etc/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
	sudo ln -s /etc/chromium /etc/chromium-browser
fi

sudo cp -f $baserep/dans_icones/scripts/linux/chromium/master_preferences /etc/chromium-browser/master_preferences
sudo ln -s /etc/chromium-browser/master_preferences /etc/chromium/master_preferences
echo "---Fin installation de chromium---"
