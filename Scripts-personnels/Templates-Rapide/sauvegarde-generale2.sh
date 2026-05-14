#!/bin/bash

echo "🧠 BernardOps — nana-clean-status-merge.sh"
echo "────────────────────────────────────────────"

echo "📋 MENU BERNARDOPS GIT"
echo "1) Voir fichiers modifiés / non suivis"
echo "2) Ajouter + Commit"
echo "3) Voir statut Git complet"
echo "4) Fusionner une branche"
echo "5) Nettoyer les branches locales fusionnées"
echo "6) Voir les 5 derniers commits"
echo "7) Afficher le pense-bête Git"
echo "8) Lister les remotes"
echo "9) Ajouter un remote 'origin'"
echo "10) Supprimer un remote"
echo "11) Modifier l’URL d’un remote"
echo "12) Vérifier la connexion SSH"
echo "13) Retour menu Git"
echo "0) Quitter"
echo "────────────────────────────────────────────"

read -p "👉 Choisis une option : " choix

case "$choix" in

  1)
    echo "📦 Fichiers modifiés ou non suivis :"
    git status --short
    ;;

  2)
    echo "📦 Fichiers modifiés ou non suivis :"
    git status --short
    read -p "👉 Ajouter et committer ces fichiers ? (y/n) : " stage_ok
    if [[ "$stage_ok" == "y" ]]; then
      git add -A
      read -p "📝 Message de commit : " commit_msg
      git commit -m "$commit_msg"
      echo "✅ Fichiers ajoutés et commités"
    fi
    ;;

  3)
    echo "📊 Statut Git complet :"
    git status
    ;;

  4)
    current_branch=$(git branch --show-current)
    echo "📍 Branche actuelle : $current_branch"
    echo "🌿 Branches disponibles :"
    git branch --all | grep -v remotes | sed 's/..//'

    read -p "👉 Quelle branche veux-tu fusionner dans '$current_branch' ? " source_branch
    if git show-ref --verify --quiet refs/heads/"$source_branch"; then
      echo "🔄 Fusion de '$source_branch' dans '$current_branch'..."
      git merge "$source_branch"
      echo "✅ Fusion terminée"
      read -p "🚀 Pousser vers GitHub ? (y/n) : " push_ok
      [[ "$push_ok" == "y" ]] && git push
    else
      echo "❌ Branche '$source_branch' introuvable"
    fi
    ;;

  5)
    current_branch=$(git branch --show-current)
    echo "🔍 Suppression des branches locales fusionnées dans '$current_branch'..."
    git branch --merged | grep -v "\*" | grep -v "$current_branch" | while read branch; do
      echo "🗑️ Suppression : $branch"
      git branch -d "$branch"
    done
    echo "✅ Nettoyage terminé"
    ;;

  6)
    current_branch=$(git branch --show-current)
    echo "🧾 Derniers commits sur '$current_branch' :"
    git log -n 5 --oneline --graph --decorate
    ;;

  7)
    echo "🔹 git status        ➤ Voir les fichiers modifiés"
    echo "🔹 git add -A        ➤ Ajouter tous les fichiers"
    echo "🔹 git commit -m     ➤ Créer un commit"
    echo "🔹 git push          ➤ Envoyer vers GitHub"
    echo "🔹 git pull          ➤ Récupérer les dernières modifs"
    echo "🔹 git branch        ➤ Voir les branches locales"
    echo "🔹 git merge         ➤ Fusionner une branche"
    echo "🔹 git log --oneline ➤ Historique visuel des commits"
    echo "🔹 git log --pretty=oneline
    ;;

  8)
    git remote -v
    ;;

  9)
    read -p "URL du dépôt distant (SSH recommandé): " url
    git remote add origin "$url"
    echo "✅ Remote 'origin' ajouté : $url"
    ;;

  10)
    read -p "Nom du remote à supprimer: " remote_name
    git remote remove "$remote_name"
    echo "✅ Remote '$remote_name' supprimé"
    ;;
   
  11)
    read -p "Nom du remote à modifier: " remote_name
    read -p "Nouvelle URL: " new_url
    git remote set-url "$remote_name" "$new_url"
    echo "✅ Remote '$remote_name' mis à jour → $new_url"
    ;;

  12)
    echo "🔑 Test de connexion SSH vers GitHub..."
    ssh -T git@github.com
    ;;

    13)
    bash ./git-cockpit.sh
    
    

esac


  
    
