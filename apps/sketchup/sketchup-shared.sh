#!/bin/bash
# Attribution du dossier WINESKET
# $1 : username
groupe=$(id -gn $1)
uid=$(id -u $1)
WINESKET=/var/WINE
home=$(eval echo ~$1)
lien=$home/.PlayOnLinux
 
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