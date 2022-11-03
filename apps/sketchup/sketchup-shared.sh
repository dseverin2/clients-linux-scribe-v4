#!/bin/bash
# Attribution du dossier WINESKET
# $1 : username
# 03/11/2022
groupe=$(id -gn $1)
uid=$(id -u $1)
WINESKET=/var/WINE
home=$(eval echo ~$1)
lien=$home/.wine
 
# Sauvegarde du lien précédent
if [ -d "$lien" ]; then
    mv $lien $lien.bak
fi

# Changement de propriétaire du dossier de WINESKET
chown -h -R $1:$groupe $WINESKET
ln -s $WINESKET $lien
chown -h -R $1:$groupe $lien
# Copie des raccourcis sur le bureau
cp --preserve=ownership $WINESKET/shortcuts/*.desktop $home/Bureau
sed -i "s|\/home\/[a-Z]*\/.wine|$HOME\/.wine|g" $home/Bureau/SketchUp*.desktop
chmod a+x $home/Bureau/SketchUp\ 2017.desktop
gio set $home/Bureau/SketchUp\ 2017.desktop metadata::trusted true