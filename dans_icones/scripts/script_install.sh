#!/bin/bash

echo "1-Initialisation du fichier de log"
logfile="/etc/esubuntu/log_esubuntu.log"
touch $logfile

# Vérification du /etc/sudoers
echo "2-Vérification du fichier des sudoers"
if ! grep "%professeurs ALL=(ALL) ALL" /etc/sudoers > /dev/null; then
	echo "--- Mise à jour nécessaire"
	sed -i "/%admin ALL=(ALL) ALL/a\%professeurs ALL=(ALL) ALL" /etc/sudoers 2>> $logfile
	sed -i "/%admin ALL=(ALL) ALL/a\%DomainAdmins ALL=(ALL) ALL" /etc/sudoers 2>> $logfile
fi

# MAJ user apt dans proxy
echo "3-Vérification du proxy pour APT"
if ! grep "esubuntuapt" /etc/apt/apt.conf.d/20proxy > /dev/null; then
	echo "--- Mise à jour nécessaire"
	sed -i 's/apt.esubuntu/esubuntuapt/g' /etc/apt/apt.conf.d/20proxy 2>> $logfile
fi
if grep "https://" /etc/apt/apt.conf.d/20proxy > /dev/null; then
	sed -i 's/https:\//http:\//g' /etc/apt/apt.conf.d/20proxy 2>> $logfile
fi

# MAJ user wgetrc proxy
echo "4-Vérification du proxy pour wget"
if ! grep "esubuntuapt" /etc/wgetrc > /dev/null; then
	echo "--- Mise à jour nécessaire"
	sed -i 's/apt.esubuntu/esubuntuapt/g' /etc/wgetrc 2>> $logfile
fi
if ! grep "esubuntuapt" /etc/environment > /dev/null; then
	sed -i 's/172.18.248.1/esubuntuapt:Zaf1r4poRSrt4dkkfs2d12z5@172.18.248.1/g' /etc/environment 2>> $logfile
fi


# Suppression de la mise en veille
echo "5-Suppression de la mise en veille"
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Récupération et application de la configuration du poste
echo "6-Récupération et application de la configuration du poste"
source /tmp/netlogon/icones/scripts/installScripts/_configALL.sh

# Installations et Désinstallations (Modifiables)
echo "7-Lancement des installations et désinstallations"
source /tmp/netlogon/icones/scripts/installScripts/_installALL.sh
