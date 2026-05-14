#!/bin/bash

echo "🧠 BernardOps — Nettoyage du dernier commit Git"

# Afficher la branche active
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "📦 Branche active : $current_branch"

# Vérifier qu'il y a un commit
if ! git rev-parse HEAD >/dev/null 2>&1; then
  echo "⚠️ Aucun commit à nettoyer — dépôt vide"
  exit 1
fi

# Étape 1 : Voir le dernier commit
read -p "🔍 Voir le dernier commit ? (y/n) " show_log
if [[ "$show_log" =~ ^[Yy]$ ]]; then
  git log -1 --pretty=oneline
fi

# Étape 2 : Modifier le message du dernier commit
read -p "📝 Nouveau message de commit (laisser vide pour ignorer) : " new_msg
if [[ -n "$new_msg" ]]; then
  git commit --amend -m "$new_msg"
  echo "✅ Message modifié avec succès"
fi

# Étape 3 : Supprimer le dernier commit (soft reset)
read -p "🗑️ Supprimer le dernier commit sans perdre les fichiers ? (y/n) " soft_reset
if [[ "$soft_reset" =~ ^[Yy]$ ]]; then
  git reset --soft HEAD~1
  echo "✅ Commit supprimé, fichiers conservés"
fi

# Étape 4 : Supprimer le dernier commit et les modifications (hard reset)
read -p "💣 Supprimer le dernier commit et les fichiers modifiés ? (y/n) " hard_reset
if [[ "$hard_reset" =~ ^[Yy]$ ]]; then
  git reset --hard HEAD~1
  echo "⚠️ Commit et modifications supprimés définitivement"
fi

# Étape 5 : Voir le log final
read -p "📜 Voir le log après nettoyage ? (y/n) " show_final_log
if [[ "$show_final_log" =~ ^[Yy]$ ]]; then
  git log --oneline -n 5
fi

# Étape 6 : Pusher vers GitHub
read -p "📤 Pusher vers GitHub ? (y/n) " push_now
if [[ "$push_now" =~ ^[Yy]$ ]]; then
  git push origin "$current_branch"
  echo "✅ Poussé vers GitHub sur $current_branch"
fi

echo "🎯 Nettoyage Git terminé avec BernardOps"