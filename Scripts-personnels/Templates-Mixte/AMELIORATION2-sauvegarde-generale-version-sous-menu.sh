#!/bin/bash

# ============================
#   🧠 BernardOps — Git Cockpit
#   git remote add <nom> <url>
#   ex. git remote add MAJ-serve-client https://github.com/bamalvict2/EPARVIER2026.git
# ============================

# Vérifier si on est dans un dépôt Git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Ce dossier n'est pas un dépôt Git."
    exit 1
fi

repo_root=$(git rev-parse --show-toplevel)
echo "📁 Dépôt détecté : $repo_root"
echo ""

# Couleurs
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# ---------------------------
# Sous-menu Remote
# ---------------------------
remote_menu() {
  while true; do
    echo -e "${CYAN}📡 MENU REMOTES${RESET}"
    echo "────────────────────────────────────────────"
    echo -e "${GREEN}1)${RESET} Lister les remotes"
    echo -e "${GREEN}2)${RESET} Ajouter un remote"
    echo -e "${GREEN}3)${RESET} Modifier l'URL d'un remote"
    echo -e "${GREEN}4)${RESET} Définir une URL de push différente"
    echo -e "${GREEN}5)${RESET} Renommer un remote"
    echo -e "${GREEN}6)${RESET} Supprimer un remote"
    echo -e "${GREEN}7)${RESET} Fetch depuis un remote"
    echo -e "${GREEN}8)${RESET} Pousser une branche vers un remote"
    echo -e "${GREEN}9)${RESET} Pruner les références distantes obsolètes"
    echo -e "${GREEN}10)${RESET} Synchroniser branche courante entre origin et MAJ-serve-client (avec confirmations)"
    echo -e "${YELLOW}b)${RESET} Retour au menu principal"
    echo "────────────────────────────────────────────"
    read -p "👉 Choisis une option remote : " rchoice

    case "$rchoice" in
      1)
        echo "📡 Remotes disponibles :"
        git remote -v
        ;;
      2)
        echo "➕ Ajouter un remote"
        read -p "Nom du remote : " rname
        read -p "URL du remote : " rurl
        if git remote | grep -q "^$rname$"; then
            echo "❌ Le remote '$rname' existe déjà."
        else
            git remote add "$rname" "$rurl"
            echo "✅ Remote '$rname' ajouté."
        fi
        git remote -v
        ;;
      3)
        echo "✏️ Modifier l’URL d’un remote"
        git remote -v
        read -p "Nom du remote à modifier : " rname
        read -p "Nouvelle URL : " newurl
        if git remote | grep -q "^$rname$"; then
            git remote set-url "$rname" "$newurl"
            echo "✅ Remote '$rname' mis à jour."
        else
            echo "❌ Remote '$rname' introuvable."
        fi
        git remote -v
        ;;
      4)
        echo "🔁 Définir une URL de push différente"
        git remote -v
        read -p "Nom du remote : " rname
        read -p "URL de push : " pushurl
        if git remote | grep -q "^$rname$"; then
            git remote set-url --push "$rname" "$pushurl"
            echo "✅ URL de push pour '$rname' mise à jour."
        else
            echo "❌ Remote '$rname' introuvable."
        fi
        git remote -v
        ;;
      5)
        echo "🔤 Renommer un remote"
        git remote -v
        read -p "Ancien nom : " oldname
        read -p "Nouveau nom : " newname
        if git remote | grep -q "^$oldname$"; then
            git remote rename "$oldname" "$newname"
            echo "✅ Remote renommé en '$newname'."
        else
            echo "❌ Remote '$oldname' introuvable."
        fi
        git remote -v
        ;;
      6)
        echo "🗑️ Supprimer un remote"
        git remote -v
        read -p "Nom du remote à supprimer : " rname
        if git remote | grep -q "^$rname$"; then
            git remote remove "$rname"
            echo "🗑️ Remote '$rname' supprimé."
        else
            echo "❌ Remote '$rname' introuvable."
        fi
        git remote -v
        ;;
      7)
        echo "⬇️ Fetch depuis un remote"
        git remote -v
        read -p "Nom du remote à fetch : " rname
        if git remote | grep -q "^$rname$"; then
            git fetch "$rname"
            echo "✅ Fetch depuis '$rname' terminé."
        else
            echo "❌ Remote '$rname' introuvable."
        fi
        ;;
      8)
        echo "⬆️ Pousser une branche vers un remote"
        git branch -vv
        read -p "Nom du remote : " rname
        read -p "Branche locale à pousser (ex: main) : " branch
        read -p "Définir l'upstream ? (y/n) : " setu
        if [[ "$setu" == "y" || "$setu" == "Y" ]]; then
          git push -u "$rname" "$branch"
        else
          git push "$rname" "$branch"
        fi
        ;;
      9)
        echo "🧹 Pruner les références distantes obsolètes"
        git remote -v
        read -p "Nom du remote à pruner : " rname
        if git remote | grep -q "^$rname$"; then
            git remote prune "$rname"
            echo "✅ Prune pour '$rname' terminé."
        else
            echo "❌ Remote '$rname' introuvable."
        fi
        ;;
      10)
        echo "🔀 Synchroniser branche courante entre origin et MAJ-serve-client (avec confirmations)"
        current=$(git branch --show-current)
        if [ -z "$current" ]; then
          echo "❌ Impossible de déterminer la branche courante."
        else
          echo "Branche courante : $current"
          if git remote | grep -q "^origin$" && git remote | grep -q "^MAJ-serve-client$"; then
            echo "⬇️ Fetch origin et MAJ-serve-client"
            git fetch origin
            git fetch MAJ-serve-client

            read -p "➡️ Pousser $current vers origin ? (y/n) : " ok_origin
            if [[ "$ok_origin" == "y" || "$ok_origin" == "Y" ]]; then
              echo "⬆️ Poussée vers origin..."
              git push origin "$current"
              echo "✅ Push vers origin terminé."
            else
              echo "⏭️ Push vers origin annulé."
            fi

            read -p "➡️ Pousser $current vers MAJ-serve-client ? (y/n) : " ok_maj
            if [[ "$ok_maj" == "y" || "$ok_maj" == "Y" ]]; then
              echo "⬆️ Poussée vers MAJ-serve-client..."
              git push MAJ-serve-client "$current"
              echo "✅ Push vers MAJ-serve-client terminé."
            else
              echo "⏭️ Push vers MAJ-serve-client annulé."
            fi

            echo "✅ Synchronisation terminée pour $current (actions appliquées selon confirmations)."
          else
            echo "❌ Les remotes 'origin' et/ou 'MAJ-serve-client' sont introuvables."
            git remote -v
          fi
        fi
        ;;
      b|B)
        break
        ;;
      *)
        echo "Option inconnue."
        ;;
    esac

    echo ""
    read -p "Appuie sur Entrée pour continuer..." tmp
    echo ""
  done
}

# ---------------------------
# Menu principal
# ---------------------------
echo -e "${CYAN}🧭 MENU GIT BERNARDOPS${RESET}"
echo "────────────────────────────────────────────"
echo -e "${GREEN}1)${RESET} Voir fichiers modifiés / non suivis"
echo -e "${GREEN}2)${RESET} Voir statut Git complet"
echo -e "${GREEN}3)${RESET} Voir les 5 derniers commits"
echo -e "${GREEN}4)${RESET} Voir log graphique"
echo -e "${YELLOW}5)${RESET} Ajouter + Commit"
echo -e "${YELLOW}6)${RESET} Nettoyer les branches locales fusionnées"
echo -e "${YELLOW}7)${RESET} Fusionner une branche"
echo -e "${CYAN}8)${RESET} Menu Remote"
echo -e "${CYAN}9)${RESET} Ajouter un remote (raccourci)"
echo -e "${CYAN}10)${RESET} Modifier l’URL d’un remote (raccourci)"
echo -e "${CYAN}11)${RESET} Supprimer un remote (raccourci)"
echo -e "${CYAN}12)${RESET} Vérifier la connexion SSH"
echo -e "${GREEN}13)${RESET} Afficher le pense-bête Git"
echo -e "${GREEN}14)${RESET} Retour menu principal"
echo -e "${RED}0)${RESET} Quitter"
echo "────────────────────────────────────────────"

read -p "👉 Choisis une option : " choix

case "$choix" in

  1)
    echo "📦 Fichiers modifiés / non suivis :"
    git status --short
    ;;

  2)
    echo "📊 Statut Git complet :"
    git status
    ;;

  3)
    echo "🧾 Derniers commits :"
    git log -n 5 --oneline --graph --decorate
    ;;

  4)
    echo "📈 Log graphique :"
    git log --oneline --graph --decorate --all
    ;;

  5)
    git status --short
    read -p "Ajouter et committer ? (y/n) : " ok
    if [[ "$ok" == "y" || "$ok" == "Y" ]]; then
      git add -A
      read -p "Message de commit : " msg
      git commit -m "$msg"
      echo "✅ Commit effectué."
    fi
    ;;

  6)
    current=$(git branch --show-current)
    echo "🧹 Nettoyage des branches fusionnées dans $current"
    git branch --merged | grep -v "\*" | grep -v "$current" | while read b; do
      echo "🗑️ Suppression : $b"
      git branch -d "$b"
    done
    echo "✅ Nettoyage terminé."
    ;;

  7)
    current=$(git branch --show-current)
    echo "📍 Branche actuelle : $current"
    git branch
    read -p "Fusionner quelle branche dans $current ? " src
    git merge "$src"
    ;;

  8)
    remote_menu
    ;;

  9)
    echo "➕ Ajouter un remote (raccourci)"
    read -p "Nom du remote : " rname
    read -p "URL du remote : " rurl
    if git remote | grep -q "^$rname$"; then
        echo "❌ Le remote '$rname' existe déjà."
    else
        git remote add "$rname" "$rurl"
        echo "✅ Remote '$rname' ajouté."
    fi
    git remote -v
    ;;

  10)
    echo "✏️ Modifier l’URL d’un remote (raccourci)"
    git remote -v
    read -p "Nom du remote à modifier : " rname
    read -p "Nouvelle URL : " newurl
    if git remote | grep -q "^$rname$"; then
        git remote set-url "$rname" "$newurl"
        echo "✅ Remote mis à jour."
    else
        echo "❌ Remote '$rname' introuvable."
    fi
    git remote -v
    ;;

  11)
    echo "🗑️ Supprimer un remote (raccourci)"
    git remote -v
    read -p "Nom du remote à supprimer : " rname
    if git remote | grep -q "^$rname$"; then
        git remote remove "$rname"
        echo "🗑️ Remote supprimé."
    else
        echo "❌ Remote '$rname' introuvable."
    fi
    git remote -v
    ;;

  12)
    echo "🔑 Test SSH GitHub :"
    ssh -T git@github.com
    ;;

  13)
    echo "📘 Pense-bête Git :"
    echo "🔹 git status — Voir les fichiers modifiés"
    echo "🔹 git add -A — Ajouter tous les fichiers"
    echo "🔹 git commit -m — Commit"
    echo "🔹 git push remote branche — Pousser"
    echo "🔹 git pull — Récupérer"
    echo "🔹 git branch — Voir les branches"
    echo "🔹 git merge — Fusionner"
    echo "🔹 git log — Historique"
    echo "🔹 A FAIRE FIN DE PRJ"
    echo "🔹 git status"
    echo "🔹 git checkout -b fin-creation-image-projet"
    echo "🔹 git push -u origin fin-creation-image-projet"    
    ;;

  14)
    bash ./git-cockpit.sh
    ;;

  0)
    echo "🧠 BernardOps terminé. Bon vol, Bernard 🐅"
    exit 0
    ;;

  *)
    echo "Option inconnue."
    ;;
esac