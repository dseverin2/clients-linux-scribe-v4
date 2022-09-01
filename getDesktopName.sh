#!/bin/bash
# Définition de l'archive skel en fonction du nom du répertoire "Bureau" ou "Desktop"
#

thisrep=$(cd $( dirname ${BASH_SOURCE[0]}) && pwd )
conf="$thisrep/config.cfg"
if [ -d ~/Desktop ]; then sed -i -e "s/desktopDirName/skel-desktop.tar.gz/g" "$conf"; fi
if [ -d ~/Bureau ]; then sed -i -e "s/desktopDirName/skel-bureau.tar.gz/g" "$conf"; fi
