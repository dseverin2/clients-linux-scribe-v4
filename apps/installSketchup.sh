#!/bin/sh
# Script original de Didier SEVERIN (11/09/22)

env WINEPREFIX=$HOME/winedotnet wineboot --init
env WINEPREFIX=$HOME/winedotnet winetricks dotnet452 corefonts
export WINEARCH=win64
winetricks vcrun2013 vcrun2015 corefonts
winetricks win7
# Not sur the above works, seems better when launching winetricks, default config then in settings selecting win7.
# Download from https://www.sketchup.com/fr/sketchup/2017/en/sketchupmake-2017-2-2555-90782-en-x64-exe
wget https://prod.downloadnow.com/s/16/24/59/22/sketchupmake-2017-2-2555-90782-en-x64.exe?GoogleAccessId=download-sps-prod@i-cmb-prod.iam.gserviceaccount.com&Expires=1662922938&Signature=SyV53VUIxznmDgEaeLvE%2B75H8FUVUPkFuoidBgIwNvNfNca4i9W1ORBUBfTnwGJmvo6BzhPMcXJEMamMyfIOAWZLfFuRGwppdzk45xCcrPgk%2BvRjtqvpzbFr0J6HJ9OWVFZnb0%2FzkoqOv%2FwkV6ZKfe1DvU0melbeNkuJIMP84iklHjPS1CF2o9AG%2FK5WZEJ9GglPSGM73Rripp7gNgBvMC5Z%2B4xBa%2F0frfZ68qU17HpjW6pm5cXyqv8YsmXBsrhGc3WFvt%2FUOKycQi6qtY3iwP5E28Vd44vK3EvqEXr%2BXxv2noaZVnDOtbKy4Q3H132xCLwN1KDmMamrqtuHXBFgew%3D%3D
wine sketchupmake-2017-2-2555-90782-en-x64-exe
