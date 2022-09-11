function FindProxyForURL(url, host) {

	// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	// =-=-=-=   Fichier proxy.pac -configuration pour metice pc linux
	// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	// =-=-=-=
	// =-=-=-=   Dernière modification : CALPETARD Olivier 13/06/2017
	// =-=-=-=   
	// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if (shExpMatch(host, "hubole.ac-reunion.fr")) 
	return "PROXY PROXY_IP:PROXY_PORT";
	else if (shExpMatch(host, "sso.ac-reunion.fr"))
	return "PROXY PROXY_IP:PROXY_PORT";
	else if (shExpMatch(host, "seshat.ac-reunion.fr"))
	return "PROXYPROXY_IP:PROXY_PORT";
	else if (shExpMatch(host, "IP_PRONOTE"))
	return "DIRECT";
	else if (shExpMatch(host, "easidoc.fr"))
	return "PROXY PROXY_IP:PROXY_PORT";
	else if (shExpMatch(host, "poppy-project.org"))
	return "PROXY PROXY_IP:PROXY_PORT";
	
	

	
	
	// -----
	// Vers le proxy par défaut pour les autres destinations
	// -----
	else
	return "PROXY 127.0.0.1:PROXY_PORT"
}

