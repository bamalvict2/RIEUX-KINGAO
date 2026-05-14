#!/bin/bash

echo "=== Suppression des anciens profils Firefox ==="
rm -rf ~/.mozilla

echo "=== Suppression des restes de Firefox-ESR dans /opt ==="
sudo rm -rf /opt/firefox-esr
sudo rm -f /opt/firefox-esr.tar.bz2

echo "=== Installation de Firefox stable dans /opt ==="
cd ~/Téléchargements
sudo tar -xjf firefox-*.tar.bz2 -C /opt

echo "=== Mise en place de Firefox stable comme navigateur par défaut ==="
sudo update-alternatives --install /usr/bin/firefox firefox /opt/firefox/firefox 200
sudo update-alternatives --config firefox

echo "=== Lancement de Firefox stable ==="
/opt/firefox/firefox &

echo "=== Terminé : Firefox est propre, neuf et par défaut ==="
