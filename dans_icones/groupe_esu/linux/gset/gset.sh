#!/bin/bash

#### personnalisation environnement session ubuntu ####
# - executer a chaque ouverture de session
# - gestion des restriction gsetting
# - ver 2.0.1
# - 3 mai 2018
# - CALPETARD Olivier
gsettings set  org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.system.proxy mode 'manual'
gsettings set org.gnome.system.proxy.http host 'GSETPROXY'
gsettings set org.gnome.system.proxy.http port GSETPROXYPORT
gsettings set org.gnome.system.proxy.https host 'GSETPROXY'
gsettings set org.gnome.system.proxy.https port GSETPROXYPORT
gsettings set org.gnome.system.proxy.ftp host 'GSETPROXY'
gsettings set org.gnome.system.proxy.ftp port GSETPROXYPORT
gsettings set org.gnome.system.proxy.socks host 'GSETPROXY'
gsettings set org.gnome.system.proxy.socks port GSETPROXYPORT
gsettings set org.gnome.system.proxy ignore-hosts "['localhost', 'GSETPROXY/8', 'SUBNET/21', 'IP_PRONOTE']"
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'false'
gsettings set org.gnome.desktop.session idle-delay 0
#gsettings set org.gnome.settings-daemon.plugins.print-notifications active false
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position LEFT
#gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true



