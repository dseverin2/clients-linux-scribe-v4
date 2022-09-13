echo "install chromium"
echo "deb http://deb.debian.org/debian/ stable main
deb http://deb.debian.org/debian/ stable-updates main
deb http://deb.debian.org/debian-security stable/updates main" > /etc/apt/sources.list.d/debian-for-nosnaps.list
apt install debian-archive-keyring
apt-key add /usr/share/keyrings/debian-archive-keyring.gpg

#Bloquer tous les paquets de Debian sauf Chromium
echo "Package: *
Pin: origin "deb.debian.org"
Pin-Priority: -1

Package: chromium* libicu63 libjpeg62-turbo libvpx5 libevent-2.1-6
Pin: origin "deb.debian.org"
Pin-Priority: 99" > /etc/apt/preferences.d/debian-for-nosnaps

apt update
apt install chromium chromium-l10n
if [ -e /usr/bin/chromium-browser ]; then
        sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
fi
