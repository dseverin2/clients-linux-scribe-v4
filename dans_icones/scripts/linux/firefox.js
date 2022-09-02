// Fichier configuration firefox

// Si vous utilisez un fichier de configuration de proxy, décommentez ci-dessous (+renommer fichier en quesiton) :
//pref("network.proxy.autoconfig_url", "file:///tmp/netlogon/icones/posteslinux/proxy_etab.pac");

// IMPORTANT : Si votre proxy (Amon) n'est pas en 172.18.248.1:3129,  
//merci de changer les infos juste ci-dessous :
pref("network.proxy.ftp", "172.18.248.1");
pref("network.proxy.ftp_port", 3129);
pref("network.proxy.http", "172.18.248.1");
pref("network.proxy.http_port", 3129);
pref("network.proxy.share_proxy_settings", true);
pref("network.proxy.socks", "172.18.248.1");
pref("network.proxy.socks_port", 3129);
pref("network.proxy.ssl", "172.18.248.1");
pref("network.proxy.ssl_port", 3129);
pref("network.proxy.type", 1);

//pref("network.proxy.share_proxy_settings", true);
pref("network.proxy.no_proxies_on", "127.0.0.1, localhost");
pref("signon.autologin.proxy", true);

// Page de démarrage
pref("browser.newtabpage.activity-stream.default.sites", "http://www.qwant.com", "http://hubole.ac-reunion.fr", "https://portail.college-boisdenefles.ac-reunion.fr/envole");
pref("browser.startup.homepage", "http://hubole.ac-reunion.fr", locked);

//disable default browser check
pref("browser.shell.checkDefaultBrowser", false);

//disable application updates
pref("app.update.enabled", false);

//disables the 'know your rights' button from displaying on first run 
pref("browser.rights.3.shown", true);

//disables the request to send performance data from displaying
pref("toolkit.telemetry.prompted", 2);
pref("toolkit.telemetry.rejected", true);

//proxy
pref("network.negotiate-auth.allow-proxies ", false);
pref("network.automatic-ntlm-auth.allow-proxies", false);

//Download
lockPref("browser.download.manager.closeWhenDone", true);
lockPref("browser.download.manager.retention", 0);
lockPref("browser.download.useDownloadDir", false);
