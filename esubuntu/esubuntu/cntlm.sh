#!/bin/bash

#### chargement de cntlm proxy authentifiant ####
# - génère le fichier  cntlm.conf dans le dossier doc du client
# - ver 2.1
# - 28 Mars 2020
# - CALPETARD Olivier
# - SEVERIN Didier
# a modifier les adresses ip, le domaine, les diferrents message perso
#lancement 

esublogfile="/tmp/esubcntlm.log"

echo `date` > $esublogfile
echo "Arrêt du service cntlm" >> $esublogfile
killall cntlm


echo "lecture du fichier configuration etab" >> $esublogfile
. /etc/esubuntu/param_etab.conf



if [ -d "/$HOME/.gconf" ]; then 
	echo "le dossier /$HOME/.gconf existe" >> $esublogfile
else
	echo "ERREUR : le dossier /$HOME/.gconf n'existe pas" >> $esublogfile
fi

if [ -f /$HOME/Documents/cntlm.conf ]; then 
	echo "Le fichier /$HOME/Documents/cntlm.conf existe" >> $esublogfile
	# déjà configuré on lance cntlm
else
	echo "ERREUR : Le fichier /$HOME/Documents/cntlm.conf n'existe pas !" >> $esublogfile
	echo "Création du formulaire en stockant les valeurs de sortie dans $cfgpass :/" >> $esublogfile
cfgpass=`zenity --forms \
    --title="Connexion proxy $NOM_ETAB" \
    --text="$LOGNAME Entrez vos paramètres d'authentifications sur le RESEAU PEDAGOGIQUE"\
    --add-password="Entrez votre mot de passe" \
    --separator="|"`

case $? in
    0)
    
user=$LOGNAME
pass=$(cut -d \| -f1 <<< "$cfgpass")

echo "On génère le fichier conf pour cntlm avec l'identifiant scribe :" >> $esublogfile
echo "Username	$LOGNAME
Domain		$domaine_local
Auth		$TYPE_AUTH
Proxy		$PROXY
NoProxy		$NOPROXY
Listen		$PORTCNTLM" > /$HOME/Documents/cntlm.conf
cat /$HOME/Documents/cntlm.conf >> $esublogfile
    
echo "Génération du mot de passe en hasch pour fichier conf du cntlm" >> $esublogfile
echo $pass | cntlm -H -d $domaine_local -u $LOGNAME >> /$HOME/Documents/cntlm.conf

sed -i "s/Password://g" /$HOME/Documents/cntlm.conf
 ;;


    1)
        echo "annulé"
	;;
    -1)
        echo "Une erreur inattendue est survenue."
	;;
esac

fi

echo "Controle si cntlm est bon :" >> $esublogfile
if [ -s /$HOME/Documents/cntlm.conf ]; then
	echo "Fichier non vide" >> $esublogfile
else
	echo "fichier vide -- votre session est pleine" >> $esublogfile
	zenity --error --text "Bonjour $USER, vous avez dépassé votre quota sur votre espace personnel, veuillez contacter l'administrateur réseau $AIDE"

	rm /$HOME/Documents/cntlm.conf
	exit 0
fi

echo "Lancement de cntlm" >> $esublogfile 	
cntlm -c /$HOME/Documents/cntlm.conf

exit 0

  
