#!/bin/sh
echo "install chromium"

add-apt-repository ppa:system76/pop
apt install chromium chromium-sandbox chromium-l10n chromium-shell chromium-driver

if [ -e /usr/bin/chromium-browser ]; then
        sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
fi
