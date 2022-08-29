#!/bin/bash

# Liste des fonctions utilisées :
# addtoend Ajoute les lignes données en paramètres à la fin du fichier donné en 1er paramètre si elles ne sont pas déjà présentes.
# initlog Initialise le fichier de log avec la date du jour
# writelog Ecrit les éléments donnés en paramètres à la suite du fichier de log (Si le 1er argument est INITBLOC, insère ******* au préalable. Si le 1er argument est ENDBLOC, insère ******)
# getversion Récupère la version d'ubuntu utilisée et interrompt le script si elle n'est pas compatible


if [ -e ./config.cfg ]; then
	source ./config.cfg
elif [ -e ../config.cfg ]; then
	source ../config.cfg
else
	echo "Fichier config.cfg absent ! Interruption de l'installation."
	exit
fi
touch $logfile

# Ajout locate
sudo apt install locate -y

# Test Mise à jour
function majIntegrdom {
	wget --no-check-certificate -O /tmp/_VERSION https://github.com/dseverin2/clients-linux-scribe-v4/raw/main/_VERSION
	source /tmp/_VERSION
	onlineVersion=$versionscript
	if [ -e ./_VERSION ]; then
		source ./_VERSION
		offlineVersion=$versionscript
	else
		offlineVersion=""
		echo "Fichier _VERSION absent !"
	fi

	if [ "$offlineVersion" -lt "$onlineVersion" ]; then
		echo "Une nouvelle version du script est en ligne. Voulez-vous mettre à jour ? o/[N]"
		read -r autorisationMaj
		if [ "$autorisationMaj" == "o" ] || [ "$autorisationMaj" == "O" ]; then
			echo "Mise à jour du script..."
			wget --no-check-certificate https://github.com/dseverin2/clients-linux-scribe-v4/archive/master.zip
			if [ -e master.zip ]; then
				unzip master.zip
				cp -fr clients-linux-scribe-master/* .
				rm -fr clients-linux-scribe-master/ master.zip
			elif [ -e clients-linux-scribe-v4-main.zip ]; then
				unzip clients-linux-scribe-v4-main.zip
				cp -fr clients-linux-scribe-v4-main/* .
				rm -fr clients-linux-scribe-v4-main/ clients-linux-scribe-v4-main.zip
			fi
			chmod +x ./*.sh
			clear
			echo "Scripts mis à jour... reconfiguration"
			source ./Configurer.sh
		else
			echo "Aucune modification apportée aux scripts présents"
		fi
	fi
}


# Initialisation du fichier de log (situé sur le bureau de l'admin local)
function initlog {
	if [ -e $logfile ]; then
		rm -fr $logfile
	fi
	date > $logfile
}

# Ecriture des paramètres dans le fichier de log
function writelog {
	if [ "$1" = "ENDBLOC" ]; then
		echo "************************ END *************************" >> $logfile
		echo "" >> $logfile
	else
		if [ "$1" = "INITBLOC" ]; then
			echo "" >> $logfile
			echo "************************ INIT *************************" >> $logfile
		fi
		for param in "$@" 
		do 
			if [ ! "$param" = "INITBLOC" ]; then
				echo -e "$param"
				echo -e "$param" >> $logfile
			fi
		done
	fi
}

# Affectation à la variable "version" suivant la variante utilisé
function getversion {	
	# Pour identifier le numéro de la version (14.04, 16.04...)
	. /etc/lsb-release
	
	version=$DISTRIB_CODENAME
}

# Ecriture du 1er paramètre à la suite du fichier indiqué par le 2e argument
function addtoend {
	for param in "$@" 
	do
		if [ "$1" = "$param" ]; then
			destfile=$param
		else
			if [ -e "$destfile" ]; then
				if ! grep "$param" "$destfile" > /dev/null; then
					echo "$param" | tee -a "$destfile"
				fi
			else
					echo "$param" | tee "$destfile"
			fi
		fi
	done
}
