echo "install chromium"
#!/bin/sh
sudo apt -y remove chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra
cat <<EOF >/etc/apt/sources.list.d/debian.list
deb http://ftp.debian.org/debian unstable main contrib non-free
EOF
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
cat <<EOF >/etc/apt/preferences.d/chromium.pref
Package: *
Pin: release o=Ubuntu
Pin-Priority: 500

Package: *
Pin: release o=Debian
Pin-Priority: 300

# Pattern includes 'chromium', 'chromium-browser' and similarly named
# dependencies, and the Debian ffmpeg packages that conflict with the Ubuntu
# versions.
Package: chromium* src:ffmpeg*
Pin: release o=Debian
Pin-Priority: 700
EOF

sudo apt -y update
sudo apt -y -t unstable install chromium chromium-sandbox chromium-l10n chromium-shell chromium-driver

# Add --no-sandbox option to .desktop file for Termux, sandbox does not work
# with proot.
if [ -n "$ANDROID_ROOT" ]; then
	mkdir -p ~/.local/share/applications
	sed -e 's,^Exec=/usr/bin/chromium ,& --no-sandbox ,' /usr/share/applications/chromium.desktop \
		> ~/.local/share/applications/chromium.desktop

	update-desktop-database >/dev/null 2>&1
fi

if [ -e /usr/bin/chromium-browser ]; then
        sudo ln -s /usr/bin/chromium-browser /usr/bin/chromium
elif [ -e /usr/bin/chromium ]; then
	sudo ln -s /usr/bin/chromium /usr/bin/chromium-browser
fi

#AUTREOPTION
#sudo add-apt-repository ppa:system76/pop
#sudo apt install chromium
#
