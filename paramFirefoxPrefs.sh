#!/bin/bash
addtoend /usr/lib/firefox/defaults/pref/channel-prefs.js "$pagedemarragepardefaut"  2>> $logfile
if [ "$version" = "focal" ] || [ "$version" = "jammy" ] ; then 
  echo "user_pref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\");" >> /etc/firefox/syspref.js
  echo "lockPref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\" );" >> /etc/firefox/syspref.js
  echo "user_pref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\");" >> /usr/lib/firefox/defaults/pref/all-user.js
  echo "lockPref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\" );" >> /usr/lib/firefox/defaults/pref/all-user.js
  sed -i 's/^browser\.startup\.homepage=.*$/browser.startup.homepage="http:\/\/lite.qwant.com"/' /usr/share/ubuntu-system-adjustments/firefox/distribution.ini 
######################################################################################################################
# Ci-dessus pour Mint n'ayant pas une version de firefox > 80 
# Ubuntu emplacement choisi par les distribution pour forcer les page
# /usr/lib/firefox/defaults/pref/vendor.js
# /usr/lib/chromium-browser/master_preferences && sudo rm /usr/lib/firefox/ubuntumate.cfg
# /usr/lib/firefox/defaults/pref/all-ubuntumate.js
# CI DESSOUS utilisation de https://github.com/mozilla/policy-templates/blob/master/README.md#homepage compatible firefox V 80 +
# écriture dans les deux emplacements possible (cf doc) mais fonctione avec /etc/firefox/policies/policies
######################################################################################################################
mkdir /etc/firefox/policies
echo "{
  \"policies\": {
    \"Homepage\": {
      \"URL\": \"$pagedemarragepardefaut\",
      \"Locked\": true,
      \"StartPage\": \"homepage\" 
    },
  \"OverrideFirstRunPage\": \"\"
  }
}" >> /etc/firefox/policies/policies.json

#cp /etc/firefox/policies.json /usr/lib/firefox/distribution/policies.json 
fi
