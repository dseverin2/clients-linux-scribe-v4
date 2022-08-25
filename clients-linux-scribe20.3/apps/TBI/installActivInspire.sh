# Sources originales : SEVERIN D.
# Fork réalisé par Linus HAMSTER
# https://git.linus-h.de/edular/packages/meta-activsoftware/-/snippets/4

# Add the repository signing key
$ curl -L https://apt.linus-h.de/repo_signing.key | sudo apt-key add -

# Add the repository
$ sudo apt-add-repository http://apt.linus-h.de/edular

# Update your apt cache
$ sudo apt update

# Install the metapackage
$ sudo apt install meta-activsoftware

# Reboot
$ systemctl reboot
