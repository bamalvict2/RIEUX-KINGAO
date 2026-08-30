#!/bin/bash
echo "🧹 KINGDOMAINE — nettoyage bin/obj"

MODULE_PATH="/opt/KING-AO/modules/KINGDOMAINE"

echo "🔍 Recherche des dossiers bin/obj…"
find $MODULE_PATH -type d -name "bin" -exec rm -rf {} +
find $MODULE_PATH -type d -name "obj" -exec rm -rf {} +

echo "✔ Nettoyage KINGDOMAINE terminé"
