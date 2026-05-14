#!/bin/bash

echo "------------------------------------------------------------"
echo " ANALYSE DU COMMIT EN COURS DE REBASE"
echo "------------------------------------------------------------"

echo
echo "[1] Commit HEAD actuel (celui que tu modifies) :"
git rev-parse HEAD

echo
echo "[2] Liste des fichiers contenant 'TOKEN', 'token', 'Nouveau', etc."
echo "------------------------------------------------------------"
git ls-tree -r HEAD --name-only | grep -Ei "token|Nouveau|GIT"

echo
echo "[3] Détection automatique du fichier suspect"
echo "------------------------------------------------------------"

FILE=$(git ls-tree -r HEAD --name-only | grep -Ei "TOKEN.GIT|TOKEN.GIT|Nouveau.Document.texte" | head -n 1)

if [ -z "$FILE" ]; then
    echo "Aucun fichier exact trouvé dans TOKEN GIT."
    echo "Voici les candidats possibles :"
    git ls-tree -r HEAD --name-only | grep -Ei "token"
    echo
    echo "Tu devras choisir manuellement lequel supprimer."
    exit 1
fi

echo "Fichier détecté : $FILE"

echo
echo "[4] Suppression du fichier du commit en cours"
echo "------------------------------------------------------------"
git rm --cached "$FILE"

echo
echo "[5] Amend du commit"
echo "------------------------------------------------------------"
git commit --amend --no-edit

echo
echo "[6] Continuer le rebase"
echo "------------------------------------------------------------"
git rebase --continue

echo
echo "------------------------------------------------------------"
echo " FIN DU SCRIPT — tu peux maintenant faire : git push --force"
echo "------------------------------------------------------------"
