#!/bin/bash

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

#determiner le repertoire de lancement
updatedb
chemin=$(dirname $(realpath $0)) 

#salle du pc
echo "Entrez le groupe ESU (salle): "
read salle

echo "$salle" > /etc/GM_ESU

#on lance le script prof_firefox en mode sudo 
sudo "$chemin"/firefox/prof_firefox.sh

echo "C'est fini ! bienvenue dans le groupe $salle..."
exit
