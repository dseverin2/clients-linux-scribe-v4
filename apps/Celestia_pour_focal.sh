#!/bin/bash
# version 1.0 (30/10/20)
# Didier SEVERIN (Académie de la Réunion)


wget -nc -q http://fr.archive.ubuntu.com/ubuntu/pool/universe/g/glew/libglew2.1_2.1.0-4_amd64.deb
apt install --no-install-recommends ./libglew2.1_2.1.0-4_amd64.deb -y
rm -v libglew2.1_2.1.0-4_amd64.deb
wget -nc -O- -q https://celestia.space/packages/celestia.key | sudo apt-key add -

echo deb https://celestia.space/packages focal main | sudo tee /etc/apt/sources.list.d/celestia.list
apt update 
apt install celestia -y
