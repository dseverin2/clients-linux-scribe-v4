for i in 'cdi' 'info' 'labo' 'port' 'prof' 'techno' 'ulis'; do
	scripts="/tmp/netlogon/icones/scripts"
	grpmachine="/tmp/netlogon/icones/linux-$i"
	echo ======== Déploiement vers groupe de machines : $i ========
	echo Copie des scripts pour upkg
	cp -frp $scripts/*install* /tmp/netlogon/icones/linux-$i/linux/upkg/
	cp -frp $scripts/stamp* /tmp/netlogon/icones/linux-$i/linux/upkg/
	echo Copie des scripts pour conky
	cp -frp $scripts/conky /tmp/netlogon/icones/linux-$i/
	echo Copie des scripts pour firefox
	cp -frp $scripts/linux/firefox.js /tmp/netlogon/icones/linux-$i/firefox.js
	cp -frp $scripts/chromium /tmp/netlogon/icones/linux-$i/	
	echo Creation des dossiers bureau 
	mkdir -p /tmp/netlogon/icones/linux-$i/eleves/Bureau/
	mkdir -p /tmp/netlogon/icones/linux-$i/professeurs/Bureau/
	mkdir -p /tmp/netlogon/icones/linux-$i/administratifs/Bureau/
	mkdir -p /tmp/netlogon/icones/linux-$i/DomainAdmins/Bureau/
	
	echo MàJ Bureau 1/3
	rm -fr /tmp/netlogon/icones/linux-$i/eleves/Bureau/*
	cp -fp $scripts/Bureau/*.desktop /tmp/netlogon/icones/linux-$i/eleves/Bureau/
	cp -fp $scripts/Bureau/eleves/*.desktop /tmp/netlogon/icones/linux-$i/eleves/Bureau/
	
	echo MàJ Bureau 2/3
	rm -fr /tmp/netlogon/icones/linux-$i/professeurs/Bureau/*
	cp -fp $scripts/Bureau/*.desktop /tmp/netlogon/icones/linux-$i/professeurs/Bureau/
	cp -fp $scripts/Bureau/professeurs/*.desktop /tmp/netlogon/icones/linux-$i/professeurs/Bureau/
	
	cp -fp $scripts/esubuntu/*.sh /tmp/netlogon/icones/linux-$i/esubuntu/
	cp -fp $scripts/linux/* /tmp/netlogon/icones/linux-$i/linux/
	
	echo MàJ Bureau 3/3
	rm -fr /tmp/netlogon/icones/linux-$i/_Machine/Bureau/*
	rm -fr /tmp/netlogon/icones/linux-$i/_Machine/Menu\ Démarrer/
	mkdir -p /tmp/netlogon/icones/linux-$i/_Machine/Menu\ Démarrer/
	cp -fp $scripts/Bureau/*.desktop /tmp/netlogon/icones/linux-$i/_Machine/Bureau/
	cp -fp $scripts/Menu/*.desktop /tmp/netlogon/icones/linux-$i/_Machine/Menu\ Démarrer/
done
echo "Terminé"
