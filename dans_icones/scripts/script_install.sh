#!/bin/bash

echo "1-Initialisation du fichier de log"
logfile="/etc/esubuntu/log_esubuntu.log"
touch $logfile

# Récupération et application de la configuration du poste
echo "2-Récupération et application de la configuration du poste"
source /tmp/netlogon/icones/scripts/installScripts/_configALL.sh

# Installations et Désinstallations (Modifiables)
echo "3-Lancement des installations et désinstallations"
source /tmp/netlogon/icones/scripts/installScripts/_installALL.sh
