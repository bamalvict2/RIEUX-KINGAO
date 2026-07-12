#!/bin/bash

CONFIG="$ROOT/config/kingdomaine.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo -e "\e[33m📡 Statut du module KINGDOMAINE : $NAME\e[0m"

if docker ps | grep -q "$NAME"; then
    echo -e " - $NAME : \e[32mOK\e[0m"
else
    echo -e " - $NAME : \e[31mKO\e[0m"
fi

echo -e "\e[34m[KING-AO] Fin du statut KINGDOMAINE\e[0m"

