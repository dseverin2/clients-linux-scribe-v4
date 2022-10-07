#!/bin/bash
# Définition de l'archive skel en fonction du nom du répertoire "Bureau" ou "Desktop"
#

baserep=$(cd $( dirname ${BASH_SOURCE[0]}) && pwd )
conf="$baserep/config.cfg"
deskDir=desktop
if [ -d ~/Bureau ] || [ grep Mint /etc/lsb-release ]; then deskDir=bureau; fi
sed -i -e "s/desktopDirName/skel-$deskDir.tar.gz/g" "$conf"
