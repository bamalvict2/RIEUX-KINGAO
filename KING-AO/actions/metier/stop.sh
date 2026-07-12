#!/bin/bash

echo -e "\e[33m[KING-AO] Arrêt METIER...\e[0m"

echo -e "\e[36m → Arrêt SolaizeApi...\e[0m"
docker stop solaizeapi 2>/dev/null
docker rm solaizeapi 2>/dev/null

echo -e "\e[36m → Arrêt SolaizeCockpit...\e[0m"
docker stop solaizecockpit 2>/dev/null
docker rm solaizecockpit 2>/dev/null

echo -e "\e[32m[KING-AO] METIER arrêté.\e[0m"
