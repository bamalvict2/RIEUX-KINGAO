#!/bin/bash

# Détecte automatiquement le module via son dossier
MODULE_DIR=$(basename "$(pwd)")
CONFIG="$ROOT/config/$MODULE_DIR.conf"

NAME=$(grep NAME $CONFIG | cut -d '=' -f2)
PORT=$(grep PORT $CONFIG | cut -d '=' -f2)
ENDPOINT=$(grep HEALTH $CONFIG | cut -d '=' -f2)

echo "=== ❤️ HEALTHCHECK : $NAME ==="

# Vérification du conteneur
docker ps | grep "$NAME" >/dev/null
if [ $? -eq 0 ]; then
    echo "✔ Conteneur en cours d'exécution"
else
    echo "❌ Conteneur arrêté"
fi

# Vérification du port
nc -z localhost "$PORT" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✔ Port $PORT ouvert"
else
    echo "❌ Port $PORT fermé"
fi

# Vérification de l'endpoint (si défini)
if [ -n "$ENDPOINT" ]; then
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/$ENDPOINT")
    if [ "$CODE" = "200" ]; then
        echo "✔ Endpoint /$ENDPOINT répond : 200 OK"
    else
        echo "❌ Endpoint /$ENDPOINT renvoie : $CODE"
    fi
else
    echo "ℹ Aucun endpoint HEALTH défini dans $MODULE_DIR.conf"
fi

echo "=== Fin du healthcheck ==="
