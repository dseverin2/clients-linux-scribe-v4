#!/bin/bash
if [ ! -e /usr/bin/geogebra ]; then
	echo "deb http://www.geogebra.net/linux/ stable main" | sudo tee /etc/apt/sources.list.d/geogebra.list
	sudo apt update
	sudo apt install geogebra-classic -y
fi