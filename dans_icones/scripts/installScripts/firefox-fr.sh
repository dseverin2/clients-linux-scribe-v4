sudo apt update
if [ -e /etc/firefox-esr ] || [ -e /usr/bin/firefox-esr ] || [ -e /usr/lib/firefox-esr ]; then
	sudo apt remove firefox* --purge -y
	sudo rm -fr /etc/firefox* /usr/bin/firefox* /usr/lib/firefox*
fi
echo "install firefox"
sudo apt install --fix-missing -y
sudo apt install firefox -y

echo "install locale fr"
sudo apt install --fix-missing -y
sudo apt remove firefox-locale-fr -y
sudo apt install firefox-locale-fr -y

echo "importation des profils"
if [ ! -e /etc/firefox/ ]; then
	mkdir /etc/firefox/
fi
cp /tmp/netlogon/icones/scripts/firefox/prof_firefox.sh ~
chmod +x ~/prof_firefox.sh
sudo ~/prof_firefox.sh
