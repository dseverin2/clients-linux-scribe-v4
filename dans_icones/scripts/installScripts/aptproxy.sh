#!/bin/bash
grep "http://apt.esubuntu:Zaf1r4poRSrt4dkkfs2d12z5@172.18.248.1:3129/" /etc/apt/apt.conf.d/20proxy  >/dev/null
if [ $? != 0 ]; then
	echo modif
	cp /tmp/netlogon/icones/scripts/params/20proxy /etc/apt/apt.conf.d/20proxy -f
else
	echo nomod
fi

