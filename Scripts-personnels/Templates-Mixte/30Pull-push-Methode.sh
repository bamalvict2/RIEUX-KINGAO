#!/bin/bash

while true; do
  echo "=== 🚀 Cockpit Git Principal ==="
  echo "1) Cloner un repo (avec branche)"
  echo "2) Pull (hub → local)"
  echo "3) Push (local → hub)"
  echo "4) Status"
  echo "5) Log (graph)"
  echo "6) Gestion des remotes"
  echo "7) Changer de branche"
  echo "8) Mémo Git (flux + schéma)"
  echo "9) Pré-commit cockpitifié"
  echo "10) Pull Request cockpitifiée"
  echo "q) Quitter le cockpit Git"

  read -p "Choix: " choix

  case $choix in
    1)
      ########################################
      # 📥 Clone un repo (avec branche)
      ########################################
      read -p "URL du dépôt distant (SSH recommandé): " REMOTE_URL
      read -p "Nom du dossier local: " LOCAL_DIR
      read -p "Nom de la branche à cloner: " BRANCH
      echo "🌐 Vérification du dépôt distant..."
      if ! git ls-remote "$REMOTE_URL" &>/dev/null; then
        echo "❌ Dépôt inaccessible ou inexistant sur le hub."
        continue
      fi
      git clone -b "$BRANCH" "$REMOTE_URL" "$LOCAL_DIR"
      [ $? -eq 0 ] && echo "✅ Repo cloné dans $LOCAL_DIR (branche $BRANCH)" || echo "❌ Erreur lors du clone"
      ;;
    
    2)
      ########################################
      # ⬇️ Pull hub → local
      ########################################
      if ! git diff --cached --quiet || ! git diff --quiet; then
        echo "⚠️ Il reste des modifications non commitées."
        continue
      fi
      remotes=$(git remote -v | awk '{print $1,$2}' | sort -u)
      unique_urls=$(echo "$remotes" | awk '{print $2}' | sort -u | wc -l)
      if [ "$unique_urls" -ne 1 ]; then
        echo "❌ Attention : plusieurs URLs détectées pour les remotes"
        echo "$remotes"
        continue
      fi
      if ! git ls-remote origin &>/dev/null; then
        echo "❌ Remote 'origin' inaccessible ou dépôt inexistant sur le hub."
        continue
      fi
      read -p "Nom de la branche distante (hub) à tirer: " REMOTE_BRANCH
      git fetch origin $REMOTE_BRANCH
      if git show-ref --verify --quiet refs/remotes/origin/$REMOTE_BRANCH; then
        git pull origin $REMOTE_BRANCH
        [ $? -eq 0 ] && echo "✅ Pull réussi depuis $REMOTE_BRANCH" || echo "❌ Erreur lors du pull"
      else
        echo "❌ La branche distante '$REMOTE_BRANCH' n’existe pas sur le hub."
      fi
      ;;
    
    3)
      ########################################
      # ⬆️ Push local → hub
      ########################################
      if ! git diff --cached --quiet || ! git diff --quiet; then
        echo "⚠️ Il reste des modifications non commitées."
        continue
      fi
      remotes=$(git remote -v | awk '{print $1,$2}' | sort -u)
      unique_urls=$(echo "$remotes" | awk '{print $2}' | sort -u | wc -l)
      if [ "$unique_urls" -ne 1 ]; then
        echo "❌ Attention : plusieurs URLs détectées pour les remotes"
        echo "$remotes"
        continue
      fi
      if ! git ls-remote origin &>/dev/null; then
        echo "❌ Remote 'origin' inaccessible ou dépôt inexistant sur le hub."
        continue
      fi
      read -p "Nom du remote (ex: origin, backup): " REMOTE_NAME
      read -p "Nom de la branche locale à pousser: " LOCAL_BRANCH
      read -p "Nom de la branche distante (hub): " REMOTE_BRANCH
      git fetch $REMOTE_NAME $REMOTE_BRANCH 2>/dev/null
      if git show-ref --verify --quiet refs/remotes/$REMOTE_NAME/$REMOTE_BRANCH; then
        if [ -z "$(git log $REMOTE_NAME/$REMOTE_BRANCH..$LOCAL_BRANCH --oneline)" ]; then
          echo "ℹ️ Aucun changement à pousser : $LOCAL_BRANCH → $REMOTE_BRANCH identiques"
        else
          echo "⚠️ Divergence détectée entre local et hub"
          echo "Choisis : (m) merge avec pull, (f) force push, (l) force-with-lease"
          read -p "Ton choix: " CHOIX
          case $CHOIX in
            m)
              git pull $REMOTE_NAME $REMOTE_BRANCH && \
              git push $REMOTE_NAME $LOCAL_BRANCH:$REMOTE_BRANCH
              ;;
            f)
              git push $REMOTE_NAME $LOCAL_BRANCH:$REMOTE_BRANCH --force
              ;;
            l)
              git push $REMOTE_NAME $LOCAL_BRANCH:$REMOTE_BRANCH --force-with-lease
              ;;
            *)
              echo "⚠️ Choix invalide, opération annulée"
              ;;
          esac # fin du case divergence
        fi
      else
        echo "⚠️ La branche distante '$REMOTE_BRANCH' n’existe pas encore."
        git push -u $REMOTE_NAME $LOCAL_BRANCH:$REMOTE_BRANCH
      fi
      ;;
    
    4) git status ;;
    5) git log --graph --oneline --decorate --all ;;
    
    6)
      ########################################
      # 🌐 Menu Remote
      ########################################
      while true; do
        echo "========================================"
        echo "=== 🌐 Menu Remote ==="
        echo "----------------------------------------"
        echo "📖 Les remotes sont des alias vers des dépôts distants."
        echo "👉 Tu peux en avoir plusieurs (origin, Toto, test1, test2...)."
        echo "----------------------------------------"
        echo "1) Lister les remotes"
        echo "2) Ajouter un remote"
        echo "3) Supprimer un remote"
        echo "4) Changer l’URL d’un remote"
        echo "5) Vérifier la connexion SSH"
        echo "6) Tester le remote hub (ls-remote)"
        echo "7) Vérifier cohérence noms local vs remotes"
        echo "8) Voir branches locales vs distantes et les lier"
        echo "q) Retour au cockpit Git"
        echo "========================================"
        read -p "Choix remote: " choix_remote

        case $choix_remote in
          1) git remote -v ;;
          2)
            read -p "Nom du remote: " REMOTE_NAME
            read -p "URL du dépôt distant: " REMOTE_URL
            git remote add "$REMOTE_NAME" "$REMOTE_URL"
            echo "✅ Remote '$REMOTE_NAME' ajouté : $REMOTE_URL"
            ;;
          3)
            read -p "Nom du remote à supprimer: " REMOTE_NAME
            git remote remove "$REMOTE_NAME"
            echo "✅ Remote '$REMOTE_NAME' supprimé"
            ;;
          4)
            read -p "Nom du remote à modifier: " REMOTE_NAME
            read -p "Nouvelle URL: " REMOTE_URL
            git remote set-url "$REMOTE_NAME" "$REMOTE_URL"
            echo "✅ Remote '$REMOTE_NAME' mis à jour → $REMOTE_URL"
            ;;
          5)
            ssh -T git@github.com
            ;;
          6)
            read -p "Nom du remote à tester: " REMOTE_NAME
            git ls-remote "$REMOTE_NAME"
            ;;
          7)
            git remote -v
            git branch -vv
            ;;
          8)
            git branch -vv
            for remote in $(git remote); do
              echo "--- $remote ---"
              git ls-remote --heads $remote | awk '{print $2}' | sed 's/refs\/heads\///'
            done
            read -p "Nom de la branche locale: " LOCAL_BRANCH
            read -p "Nom du remote: " REMOTE_NAME
            read -p "Nom de la branche distante: " REMOTE_BRANCH
            git branch --set-upstream-to=$REMOTE_NAME/$REMOTE_BRANCH $LOCAL_BRANCH
            echo "✅ Branche '$LOCAL_BRANCH' liée à '$REMOTE_NAME/$REMOTE_BRANCH'"
            ;;
          q) break ;; # sort du sous-menu remote
          *) echo "❌ Choix invalide" ;;
        esac # fin du case remote
      done # fin du while remote
      ;;
    
    q) break ;; # sort du cockpit principal
    *) echo "❌ Choix invalide" ;;
  esac # fin du case principal
done # fin du while principal