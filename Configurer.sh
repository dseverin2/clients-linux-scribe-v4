#!/bin/bash
# Version 16.09.2022

if $(dpkg-query -Wf'${Status}' yad 2>/dev/null | grep -q "install ok installed"); then
 sudo apt remove -y yad
fi
sudo apt install yad -y
conf="$baserep/config.cfg"
source "$conf"

retour=$(yad --title="Paramétrage Accès Web 1/3" --form\
 --field="Installation Depuis Domaine":CHK\
 --field="IP Scribe":CBE\
 --field="APT Username":CBE\
 --field="APT Password":H\
 --field="Proxy Authentifiant":CHK\
 --field="IP Proxy":CBE\
 --field="Port Proxy (défaut)":CBE\
 --field="Domaine académique":CBE\
 -- "$installdepuisdomaine" "$scribe_def_ip" "$scribeuserapt" "$scribepass" "$proxauth" "$proxy_def_ip" "$proxy_def_port" "$domaine_acad")
echo "$retour"

dom=$(echo $retour | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$dom" != "" ]; then sed -i -e "s/^installdepuisdomaine=.*/installdepuisdomaine=$dom/g" "$conf" ;fi
ipscr=$(echo $retour | awk 'BEGIN {FS="|" } { print $2 }')
if [ "$ipscr" != "" ]; then sed -i -e "s/^scribe_def_ip=.*/scribe_def_ip=\"$ipscr\"/g" "$conf"; fi
aptusr=$(echo $retour | awk 'BEGIN {FS="|" } { print $3 }')
if [ "$aptusr" != "" ]; then sed -i -e "s/^scribeuserapt=.*/scribeuserapt=\"$aptusr\"/g" "$conf"; fi
aptpass=$(echo $retour | awk 'BEGIN {FS="|" } { print $4 }')
if [ "$aptpass" != "" ]; then sed -i -e "s/^scribepass=.*/scribepass=\"$aptpass\"/g" "$conf"; fi
proxau=$(echo $retour | awk 'BEGIN {FS="|" } { print $5 }')
if [ "$proxau" != "" ]; then sed -i -e "s/^proxauth=.*/proxauth=$proxau/g" "$conf"; fi
ipprox=$(echo $retour | awk 'BEGIN {FS="|" } { print $6 }')
if [ "$ipprox" != "" ]; then sed -i -e "s/^proxy_def_ip=.*/proxy_def_ip=\"$ipprox\"/g" "$conf"; fi
portprox=$(echo $retour | awk 'BEGIN {FS="|" } { print $7 }')
if [ "$portprox" != "" ]; then sed -i -e "s/^proxy_def_port=.*/proxy_def_port=\"$portprox\"/g" "$conf"; fi
domacad=$(echo $retour | awk 'BEGIN {FS="|" } { print $8 }')
if [ "$domacad" != "" ]; then sed -i -e "s/^domaine_acad=.*/domaine_acad=\"$domacad\"/g" "$conf"; fi

retour=$(yad --title="Paramétrage Domaine & Esu 2/3" --form\
 --field="Esubuntu":CHK\
 --field="Nom Etablissement":CBE\
 --field="Port CNTLM":CBE\
 --field="Type CNTLM":CBE\
 --field="Nom Domaine Local":CBE\
 --field="SOS Problème info":CBE\
 --field="Salle":CBE\
 --field="RNE":CBE\
 --field="Info Machine":CBE\
 -- "$esubuntu" "$nom_etab" "$port_cntlm" "$type_cntlm" "$domaine_local" "$sos_info" "$salle" "$rne_etab" "$infomachine")
echo "$retour"


esu=$(echo $retour | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$esu" != "" ]; then sed -i -e "s/^esubuntu=.*/esubuntu=$esu/g" "$conf"; fi
etab=$(echo $retour | awk 'BEGIN {FS="|" } { print $2 }')
if [ "$etab" != "" ]; then sed -i -e "s/^nom_etab=.*/nom_etab=\"$etab\"/g" "$conf"; fi
pcntlm=$(echo $retour | awk 'BEGIN {FS="|" } { print $3 }')
if [ "$pcntlm" != "" ]; then sed -i -e "s/^port_cntlm=.*/port_cntlm=\"$pcntlm\"/g" "$conf"; fi
tcntlm=$(echo $retour | awk 'BEGIN {FS="|" } { print $4 }')
if [ "$tcntlm" != "" ]; then sed -i -e "s/^type_cntlm=.*/type_cntlm=\"$tcntlm\"/g" "$conf"; fi
ndom=$(echo $retour | awk 'BEGIN {FS="|" } { print $5 }' | sed 's/\//\\\//g')
if [ "$ndom" != "" ]; then sed -i -e "s/^domaine_local=.*/domaine_local=\"$ndom\"/g" "$conf"; fi
sos=$(echo $retour | awk 'BEGIN {FS="|" } { print $6 }' | sed 's/\//\\\//g')
if [ "$sos" != "" ]; then sed -i -e "s/^sos_info=.*/sos_info=\"$sos\"/g" "$conf"; fi
lieu=$(echo $retour | awk 'BEGIN {FS="|" } { print $7 }')
if [ "$lieu" != "" ]; then sed -i -e "s/^salle=.*/salle=\"$lieu\"/g" "$conf"; fi
rne=$(echo $retour | awk 'BEGIN {FS="|" } { print $8 }')
if [ "$rne" != "" ]; then sed -i -e "s/^rne_etab=.*/rne_etab=\"$rne\"/g" "$conf"; fi
infomach=$(echo $retour | awk 'BEGIN {FS="|" } { print $9 }')
if [ "$infomach" != "" ]; then sed -i -e "s/^infomachine=.*/infomachine=$infomach/g" "$conf"; fi


retour=$(yad --title="Paramétrage Applications 3/3" --form\
 --field="Page d'accueil de Firefox":CBE\
 --field="Heure d'extinction auto":CBE\
 --field="Installer logiciels recommandés":CHK\
 --field="Installer logiciels avancés":CHK\
 --field="Configurer photocopieur":CHK\
 --field="Installer eBeam":CHK\
 --field="Installer activInspire":CHK\
 --field="Installer WPS Office":CHK\
 --field="Installer Only Office Desktop":CHK\
 --field="Installer Veyon":CHK\
 --field="Installer Sketchup 2017":CHK\
 --field="Redémarrer à la fin":CHK\
 -- "$pagedemarragepardefaut" "$extinction" "$postinstallbase" "$postinstalladditionnel" "$config_photocopieuse" "$ebeam" "$activinspire" "$WPSOffice" "$OnlyOffice" "$Veyon" "$reboot")
echo "$retour"

accueil=$(echo $retour | awk 'BEGIN {FS="|" } { print $1 }' | sed 's/\//\\\//g')
if [ "$accueil" != "" ]; then sed -i -e "s/^pagedemarragepardefaut=.*/pagedemarragepardefaut=\"$accueil\"/g" "$conf"; fi
shutd=$(echo $retour | awk 'BEGIN {FS="|" } { print $2 }')
sed -i -e "s/^extinction=.*/extinction=\"$shutd\"/g" "$conf"
base=$(echo $retour | awk 'BEGIN {FS="|" } { print $3 }')
if [ "$base" != "" ]; then sed -i -e "s/^postinstallbase=.*/postinstallbase=$base/g" "$conf"; fi
add=$(echo $retour | awk 'BEGIN {FS="|" } { print $4 }')
if [ "$add" != "" ]; then sed -i -e "s/^postinstalladditionnel=.*/postinstalladditionnel=$add/g" "$conf"; fi
copieur=$(echo $retour | awk 'BEGIN {FS="|" } { print $5 }')
if [ "$copieur" != "" ]; then sed -i -e "s/^config_photocopieuse=.*/config_photocopieuse=$copieur/g" "$conf"; fi
ebe=$(echo $retour | awk 'BEGIN {FS="|" } { print $6 }')
if [ "$ebe" != "" ]; then sed -i -e "s/^ebeam=.*/ebeam=$ebe/g" "$conf"; fi
prom=$(echo $retour | awk 'BEGIN {FS="|" } { print $7 }')
if [ "$prom" != "" ]; then sed -i -e "s/^activinspire=.*/activinspire=$prom/g" "$conf"; fi
wps=$(echo $retour | awk 'BEGIN {FS="|" } { print $8 }')
if [ "$wps" != "" ]; then sed -i -e "s/^WPSOffice=.*/WPSOffice=$wps/g" "$conf"; fi
onlyof=$(echo $retour | awk 'BEGIN {FS="|" } { print $9 }')
if [ "$onlyof" != "" ]; then sed -i -e "s/^OnlyOffice=.*/OnlyOffice=$onlyof/g" "$conf"; fi
vey=$(echo $retour | awk 'BEGIN {FS="|" } { print $10 }')
if [ "$vey" != "" ]; then sed -i -e "s/^Veyon=.*/Veyon=$vey/g" "$conf"; fi
sketchup=$(echo $retour | awk 'BEGIN {FS="|" } { print $11 }')
if [ "$sketchup" != "" ]; then sed -i -e "s/^Sketchup=.*/Sketchup=$sketchup/g" "$conf"; fi
reb=$(echo $retour | awk 'BEGIN {FS="|" } { print $12 }')
if [ "$reb" != "" ]; then sed -i -e "s/^reboot=.*/reboot=$reb/g" "$conf"; fi

sed -i -e "s/TRUE/true/g" "$conf"
sed -i -e "s/FALSE/false/g" "$conf"
sudo -u "$SUDO_USER" ./getDesktopName.sh
source "$conf"
echo $infomachine | tee /etc/INFO_ESU
if [ ! -e /var/lib/man-db/auto-update ]; then touch /var/lib/man-db/auto-update; fi
