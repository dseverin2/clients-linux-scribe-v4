#!/bin/sh
echo "install chromium"

sudo add-apt-repository ppa:saiarcot895/chromium-beta -y
apt install chromium-browser --install-suggests -y

if [ -e /usr/bin/chromium-browser ]; then
        sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
fi
