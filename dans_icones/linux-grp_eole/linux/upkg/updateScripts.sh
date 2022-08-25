#!/bin/bash
for i in 'cdi' 'info' 'labo' 'port' 'prof' 'techno' 'ulis'; do
	cp -fr /tmp/netlogon/icones/scripts/*install* /tmp/netlogon/icones/linux-$i/linux/upkg/
	cp -fr /tmp/netlogon/icones/scripts/stamp* /tmp/netlogon/icones/linux-$i/linux/upkg/
	cp -f /tmp/netlogon/icones/scripts/Bureau/*.desktop /tmp/netlogon/icones/linux-$i/eleves/Bureau/
	cp -f /tmp/netlogon/icones/scripts/Bureau/*.desktop /tmp/netlogon/icones/linux-$i/professeurs/Bureau/
done
