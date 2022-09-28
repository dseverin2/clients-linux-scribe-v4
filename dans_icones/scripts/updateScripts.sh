#!/bin/bash
scripts="/tmp/netlogon/icones/scripts"
for i in `ls /tmp/netlogon/icones/ | grep 'linux'`;
	grpmachine="/tmp/netlogon/icones/$i"
	echo ======== Déploiement vers groupe de machines : $i ========
	echo "1/2 - Copie des scripts"
	#Esubuntu
	cp -fp $scripts/esubuntu/*.sh /tmp/netlogon/icones/$i/esubuntu/
	cp -fpr $scripts/linux/ /tmp/netlogon/icones/$i/
	#Installateurs communs et stamp.date
	cp -frp $scripts/*install* /tmp/netlogon/icones/$i/linux/upkg/
	cp -frp $scripts/stamp* /tmp/netlogon/icones/$i/linux/upkg/
	#Conky
	cp -frp $scripts/conky /tmp/netlogon/icones/$i/
	#Firefox & chromium
	cp -frp $scripts/linux/ /tmp/netlogon/icones/$i/
	echo "2/2 - Creation des dossiers bureau"
	for j in '_Machine' 'administratifs' 'DomainAdmins' 'eleves' 'professeurs'; do
		if [ ! -d /tmp/netlogon/icones/$i/$j/Bureau/ ]; then
			mkdir -p /tmp/netlogon/icones/$i/$j/Bureau/ /tmp/netlogon/icones/$i/$j/Menu\ Démarrer/
		else
			rm -fr /tmp/netlogon/icones/$i/$j/Bureau/*
		fi
		cp -fpr $scripts/_icones/$j/Bureau/* /tmp/netlogon/icones/$i/$j/Bureau/
		if [ ! -d /tmp/netlogon/icones/$i/$j/Menu\ Démarrer/ ]; then
			mkdir -p /tmp/netlogon/icones/$i/$j/Menu\ Démarrer/
		else
			rm -fr /tmp/netlogon/icones/$i/$j/Menu\ Démarrer/*
		fi
		cp -fpr $scripts/_icones/$j/Menu\ Démarrer/* /tmp/netlogon/icones/$i/$j/Menu\ Démarrer/
	done	
done
echo "Terminé"
