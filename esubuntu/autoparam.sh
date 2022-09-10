#!/bin/bash
autoparam {
  find $1/dans_icones/ -type f -exec sed -i -e "'s/RNE_ETAB/"$rne_etab"/g'" -e "'s/IP_SCRIBE/"$scribe_def_ip"/g'" -e "'s/IP_PRONOTE/"$pronote"/g'" -e "'s/PORTAIL/"$portail"/g'" -e "'s/SALLEESU/"$salle"/g'" -e "'s/PROXY_IP/"$proxy_def_ip"/g'" -e "'s/PROXY_PORT/"$proxy_def_port"/g'" -e "'s/GSETPROXYPORT/"$gset_proxy_port"/g'" -e "'s/GSETPROXY/"$gset_proxy"/g'" -e "'s/SUBNET/"$subnet"/g'" -e "'s/INTERFACEETH/"$interfaceeth"/g'" {} \; 2>> $logfile
}
