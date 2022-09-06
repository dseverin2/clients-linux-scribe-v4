function FindProxyForURL(url, host) {

	// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	// =-=-=-=   Fichier proxy.pac -configuration pour metice pc linux
	// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	// =-=-=-=
	// =-=-=-=   Dernière modification : CALPETARD Olivier 13/06/2017
	// =-=-=-=   
	// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=



	if (shExpMatch(host, "hubole.ac-reunion.fr")) 
	return "PROXY GSETPROXY:GSETPROXYPORT";
	else if (shExpMatch(host, "sso.ac-reunion.fr"))
	return "PROXY GSETPROXY:GSETPROXYPORT";
	else if (shExpMatch(host, "seshat.ac-reunion.fr"))
	return "PROXY GSETPROXY:GSETPROXYPORT";
	else if (shExpMatch(host, "IP_PRONOTE"))
	return "DIRECT";
	else if (shExpMatch(host, "easidoc.fr"))
	return "PROXY GSETPROXY:GSETPROXYPORT";
	else if (shExpMatch(host, "poppy-project.org"))
	return "PROXY GSETPROXY:GSETPROXYPORT";
	
	

	
	
	// -----
	// Vers le proxy par défaut pour les autres destinations
	// -----
	else
	return "PROXY 127.0.0.1:GSETPROXYPORT"
}

