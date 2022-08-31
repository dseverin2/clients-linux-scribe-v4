# Extension CMaths OOo
CMinstallfile="CmathOOo.oxt"

# Extension TexMaths
TMversion="0.48.2"
TMinstallfile="TexMaths-"$TMversion".oxt"

if [ ! -e $CMinstallfile ]; then
	wget http://cdeval.free.fr/CmathOOoUpdate/$CMinstallfile
fi
if [ ! -e $TMinstallfile ]; then
	wget https://liquidtelecom.dl.sourceforge.net/project/texmaths/$TMversion/$TMinstallfile
fi
/usr/bin/unopkg add --shared CmathOOo.oxt TexMaths*.oxt
wget http://cdeval.free.fr/IMG/ttf/Cmath.ttf -P /usr/share/fonts
wget http://cdeval.free.fr/IMG/ttf/cmathscr.ttf -P /usr/share/fonts
wget http://cdeval.free.fr/IMG/ttf/cmathcal.ttf -P /usr/share/fonts
chmod a+r /usr/share/fonts/*
fc-cache -f -v
rm -fr *.oxt
