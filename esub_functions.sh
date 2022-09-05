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
		echo "Mise à jour du script..."
		wget -nc --no-check-certificate https://github.com/dseverin2/clients-linux-scribe-v4/archive/master.zip
		if [ -e master.zip ]; then
			unzip master.zip
			cp -fr clients-linux-scribe-v4-main/* .
			rm -fr clients-linux-scribe-v4-main/ master.zip
		fi
		chmod +x ./*.sh
		clear
		echo "Scripts mis à jour... reconfiguration"
		source ./Configurer.sh
	fi
}

function paramnewldap {
echo " pre_auth-client-config # passwd:         compat systemd
passwd:  files ldap
# pre_auth-client-config # group:          compat systemd
group: files ldap
# pre_auth-client-config # shadow:         compat
shadow: files ldap
gshadow:        files
hosts:          files mdns4_minimal [NOTFOUND=return] dns myhostname
networks:       files
protocols:      db files
services:       db files
ethers:         db files
rpc:            db files
# pre_auth-client-config # netgroup:       nis
netgroup: nis
sudoers: ldap [NOTFOUND=return] files
" > /etc/nsswitch.conf 2>> $logfile
}

function paramoldldap {
writelog "Installation de auth-client-config"
wget -nc http://archive.ubuntu.com/ubuntu/pool/universe/a/auth-client-config/auth-client-config_0.9ubuntu1_all.deb
dpkg -i auth-client-config_0.9ubuntu1_all.deb 2>> $logfile
rm -f auth-client-config_0.9ubuntu1_all.deb
echo "[open_ldap]
nss_passwd=passwd:  files ldap
nss_group=group: files ldap
nss_shadow=shadow: files ldap
nss_netgroup=netgroup: nis" > /etc/auth-client-config/profile.d/open_ldap 2>> $logfile
auth-client-config -t nss -p open_ldap 2>> $logfile
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
	if [ "$DISTRIB_CODENAME"=="una" ] || [ "$DISTRIB_CODENAME"=="uma" ] || [ "$DISTRIB_CODENAME"=="ulyssa" ] || [ "$DISTRIB_CODENAME"=="ulyana" ] ; then
		version="focal"
	elif [ "$DISTRIB_CODENAME"=="vanessa" ]; then
		version="jammy"
	else
		version=$DISTRIB_CODENAME
	fi
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
