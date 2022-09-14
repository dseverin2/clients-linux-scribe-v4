echo "install chromium"
apt remove chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra
#echo "deb [arch=amd64 signed-by=/usr/share/keyrings/debian-buster.gpg] http://deb.debian.org/debian buster main
#deb [arch=amd64 signed-by=/usr/share/keyrings/debian-buster-updates.gpg] http://deb.debian.org/debian buster-updates main
#deb [arch=amd64 signed-by=/usr/share/keyrings/debian-security-buster.gpg] http://deb.debian.org/debian-security buster/updates main" > /etc/apt/sources.list.d/debian-for-nosnaps.list
apt install debian-archive-keyring
apt-key add /usr/share/keyrings/debian-archive-keyring.gpg

#Bloquer tous les paquets de Debian sauf Chromium
echo "# Note: 2 blank lines are required between entries
Package: *
Pin: release a=focal
Pin-Priority: 500

Package: *
Pin: origin "deb.debian.org"
Pin-Priority: 300

# Pattern includes 'chromium', 'chromium-browser' and similarly
# named dependencies:
Package: chromium*
Pin: origin "deb.debian.org"
Pin-Priority: 700" > /etc/apt/preferences.d/debian-for-nosnaps

apt update
apt install chromium 
apt install chromium-l10n
if [ -e /usr/bin/chromium-browser ]; then
        sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
fi
