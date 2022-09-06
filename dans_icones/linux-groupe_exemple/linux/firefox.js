// Fichier configuration firefox

// Si vous utilisez un fichier de configuration de proxy, décommentez ci-dessous (+renommer fichier en quesiton) :
//pref("network.proxy.autoconfig_url", "file:///tmp/netlogon/icones/posteslinux/proxy_etab.pac");

// IMPORTANT : Si votre proxy (Amon) n'est pas en PROXY_IP:PROXY_PORT,  
//merci de changer les infos juste ci-dessous :
pref("network.proxy.ftp", "PROXY_IP");
pref("network.proxy.ftp_port", PROXY_PORT);
pref("network.proxy.http", "PROXY_IP");
pref("network.proxy.http_port", PROXY_PORT);
pref("network.proxy.share_proxy_settings", true);
pref("network.proxy.socks", "PROXY_IP");
pref("network.proxy.socks_port", PROXY_PORT);
pref("network.proxy.ssl", "PROXY_IP");
pref("network.proxy.ssl_port", PROXY_PORT);
pref("network.proxy.type", 1);

//pref("network.proxy.share_proxy_settings", true);
pref("network.proxy.no_proxies_on", "127.0.0.1, localhost , ubuntu.com , RNE_ETAB, IP_SCRIBE, IP_PRONOTE, PORTAIL");

// Page de démarrage
pref("browser.startup.homepage", "https://lite.qwant.com");

// disable default browser check
pref("browser.shell.checkDefaultBrowser", false);

// disable application updates
pref("app.update.enabled", false)

// disables the 'know your rights' button from displaying on first run 
pref("browser.rights.3.shown", true);

// disables the request to send performance data from displaying
pref("toolkit.telemetry.prompted", 2);
pref("toolkit.telemetry.rejected", true);

// Download
lockPref("browser.download.manager.closeWhenDone", true);
lockPref("browser.download.manager.retention", 0);
lockPref("browser.download.useDownloadDir", false);
