#!/bin/bash
# Attribution du dossier POL
# $1 : username
groupe=$(id -gn $1)
uid=$(id -u $1)
POL=/var/POL
home=$(eval echo ~$1)
lien=$home/.PlayOnLinux
 
# Sauvegarde du lien précédent
if [ -d "$lien" ]; then
    mv $lien $lien.bak
fi

# Changement de propriétaire du dossier de POL
chown -h -R $1:$groupe $POL
ln -s $POL $lien
chown -h -R $1:$groupe $lien
# Copie des raccourcis sur le bureau
cp --preserve=ownership $POL/shortcuts/*.desktop $home/Bureau
