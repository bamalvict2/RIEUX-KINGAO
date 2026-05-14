# ---------------------------
# Synchroniser brouillon MAJ-serve-client vers origin avec tests
# ---------------------------
sync_brouillon_to_origin() {
  echo "🔁 Synchronisation brouillon → origin"
  read -p "Nom de la branche distante sur MAJ-serve-client (ex: feature/x) : " remote_branch
  if [ -z "$remote_branch" ]; then
    echo "❌ Branche non fournie. Abandon."
    return
  fi

  # noms locaux temporaires
  temp_branch="tmp/from-maj-${remote_branch//\//-}"
  validated_branch="validated-${remote_branch//\//-}"

  echo "⬇️ Fetch des remotes"
  git fetch MAJ-serve-client || { echo "❌ Fetch MAJ-serve-client a échoué"; return; }
  git fetch origin || { echo "❌ Fetch origin a échoué"; return; }

  # créer branche locale depuis MAJ-serve-client
  if git show-ref --verify --quiet "refs/remotes/MAJ-serve-client/$remote_branch"; then
    git checkout -B "$temp_branch" "MAJ-serve-client/$remote_branch" || { echo "❌ Échec checkout"; return; }
  else
    echo "❌ La branche distante MAJ-serve-client/$remote_branch n'existe pas."
    return
  fi

  echo "🔧 Rebase sur origin/main pour intégrer les dernières validations"
  git rebase origin/main
  if [ $? -ne 0 ]; then
    echo "⚠️ Conflits lors du rebase. Résous-les puis relance la synchronisation."
    echo "Tu es sur la branche $temp_branch. Après résolution : git rebase --continue"
    return
  fi

  # commande de test configurable
  default_test_cmd="make test"
  read -p "Commande de test à exécuter (laisser vide pour utiliser '$default_test_cmd') : " test_cmd
  if [ -z "$test_cmd" ]; then
    test_cmd="$default_test_cmd"
  fi

  echo "🧪 Exécution des tests : $test_cmd"
  eval "$test_cmd"
  test_status=$?

  if [ $test_status -ne 0 ]; then
    echo "❌ Les tests ont échoué (code $test_status). Ne pousse pas vers origin."
    read -p "Garder la branche temporaire $temp_branch localement pour debug ? (y/n) : " keep_tmp
    if [[ "$keep_tmp" =~ ^[Yy]$ ]]; then
      echo "✅ Garde $temp_branch pour debug."
    else
      git checkout - && git branch -D "$temp_branch"
      echo "🗑️ Branche temporaire supprimée."
    fi
    return
  fi

  read -p "✅ Tests OK. Pousser $temp_branch vers origin en tant que $validated_branch ? (y/n) : " ok_push
  if [[ "$ok_push" =~ ^[Yy]$ ]]; then
    git push origin "$temp_branch:$validated_branch"
    if [ $? -ne 0 ]; then
      echo "❌ Push vers origin a échoué."
      return
    fi
    echo "✅ Branche poussée sur origin sous le nom $validated_branch"
    read -p "Supprimer la branche temporaire locale $temp_branch ? (y/n) : " del_tmp
    if [[ "$del_tmp" =~ ^[Yy]$ ]]; then
      git branch -D "$temp_branch"
      echo "🗑️ $temp_branch supprimée."
    fi
    echo "ℹ️ Tu peux maintenant ouvrir une Pull Request depuis origin/$validated_branch vers origin/main"
  else
    echo "⏭️ Push annulé. La branche temporaire reste en local : $temp_branch"
  fi
}