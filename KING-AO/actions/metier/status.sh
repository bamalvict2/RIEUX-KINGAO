#!/bin/bash

echo -e "\e[33m[KING-AO] Statut METIER\e[0m"

# SolaizeApi
echo -ne " - SolaizeApi : "
if docker ps | grep -q solaizeapi; then
    echo -e "\e[32mOK\e[0m"
else
    echo -e "\e[31mKO\e[0m"
fi

# SolaizeCockpit
echo -ne " - SolaizeCockpit : "
if docker ps | grep -q solaizecockpit; then
    echo -e "\e[32mOK\e[0m"
else
    echo -e "\e[31mKO\e[0m"
fi

echo -e "\e[34m[KING-AO] Fin du statut METIER\e[0m"
