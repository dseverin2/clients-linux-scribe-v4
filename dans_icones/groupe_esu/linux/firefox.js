// Fichier configuration firefox
pref("network.proxy.type", 2);
pref("network.proxy.autoconfig_url", "file:///tmp/netlogon/icones/SALLEESU/proxy_etab.pac");

//pref("network.proxy.share_proxy_settings", true);
pref("network.proxy.no_proxies_on", "127.0.0.1, localhost , ubuntu.com , RNE_ETAB, IP_SCRIBE, IP_PRONOTE, PORTAIL");

// Définition de la page d'accueil
pref("browser.startup.homepage", "https://www.qwant.com/ | https://metice.ac-reunion.fr");

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
