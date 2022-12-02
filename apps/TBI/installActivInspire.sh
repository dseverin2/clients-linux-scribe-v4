#!/bin/bash
# Sources originales : SEVERIN D.
# Fork réalisé par Linus HAMSTER
# https://git.linus-h.de/edular/packages/meta-activsoftware/-/snippets/4

# Add the repository signing key
#curl -L https://apt.linus-h.de/repo_signing.key | sudo apt-key add -

# Add the repository
#sudo apt-add-repository http://apt.linus-h.de/edular

# Update your apt cache
#sudo apt update

# Install the metapackage
#sudo apt install meta-activsoftware -y


#!/bin/bash
# v1.1 - 24.02.21
# Didier SEVERIN

# Installation de libssl
sudo apt install -y libssl-dev
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.10_amd64.deb
sudo dpkg -i libssl*.deb
rm -f libssl1.0.0*.deb

# Installation des librairies utilisées au lancement d'ActivInspire
wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu71_71.1-3ubuntu1_amd64.deb
sudo dpkg -i libicu*_amd64.deb
sudo apt install -y libicu71
sudo apt-get install -y gsettings-ubuntu-schemas libjpeg62

# Installation
sudo apt install -y libpcre16-3
activinspire=activinspire_1804-2.21.69365-1-amd64.deb
activdriver=activdriver_5.18.19-0~Ubuntu~2004_amd64.deb
activtools=activtools_5.18.19-0~Ubuntu~2004_amd64.deb
activaid=activaid_2.0.1-0~Ubuntu~2004_amd64.deb
if [ ! -e ./$activinspire ]; then
	googlefile=18zOHlu_ZnqBqHvtAYl7oaykLPlrjOoCW
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$googlefile' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$googlefile" -O ./$activinspire && sudo rm -rf /tmp/cookies.txt
fi
if [ ! -e ./$activdriver ]; then
	googlefile=1UmUhON4geBIRQEcmU7AdQNNuf0ql1YUH
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$googlefile' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$googlefile" -O ./$activdriver && sudo rm -rf /tmp/cookies.txt
fi
if [ ! -e ./$activtools ]; then
	googlefile=1v5ck9gI1ENGwriL1LnRL6cuumvW3jcwO
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$googlefile' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$googlefile" -O ./$activtools && sudo rm -rf /tmp/cookies.txt
fi
if [ ! -e ./$activaid ]; then
	googlefile=1ftz2fmnSLDw2YPw4bA2O1Pv30O9Q1hT7
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$googlefile' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$googlefile" -O ./$activaid && sudo rm -rf /tmp/cookies.txt
fi
sudo dpkg -i activaid*.deb activdriver*.deb activtools*.deb activinspire*.deb
sudo apt install --fix-broken -y
sudo apt autoremove -y
