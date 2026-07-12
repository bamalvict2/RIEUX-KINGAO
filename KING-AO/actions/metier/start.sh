#!/bin/bash

echo -e "\e[33m[KING-AO] Démarrage METIER...\e[0m"

# Nettoyage des anciens conteneurs
docker rm -f solaizeapi 2>/dev/null
docker rm -f solaizecockpit 2>/dev/null

# Lancement SolaizeApi
echo -e "\e[36m → Lancement SolaizeApi...\e[0m"
docker run -d \
    --name solaizeapi \
    -p 5000:5000 \
    solaizeapi:latest

# Lancement SolaizeCockpit
echo -e "\e[36m → Lancement SolaizeCockpit...\e[0m"
docker run -d \
    --name solaizecockpit \
    -p 5001:5001 \
    solaizecockpit:latest

echo -e "\e[32m[KING-AO] METIER démarré.\e[0m"
