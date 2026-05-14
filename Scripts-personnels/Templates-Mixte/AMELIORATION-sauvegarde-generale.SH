#!/bin/bash
set -e

# ────────────────────────────────────────────────────────────────
# 🧠 BernardOps – Import Windows 11 → Ubuntu (dossier Nana2)
# ────────────────────────────────────────────────────────────────

# CONFIG
MOUNT_POINT="/mnt/UBUNTUSAVEW11S"
SRC_WIN="$MOUNT_POINT/Nana2"
DEST_UBU="$HOME/Nana2"
DATE=$(date '+%Y%m%d-%H%M')

# COULEURS
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

banner() {
  clear
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗"
  echo -e "║ 🧠  BernardOps – Import Windows → Ubuntu (Nana2)     ║"
  echo -e "║ 📅  $(date '+%Y-%m-%d %H:%M')                         ║"
  echo -e "╚══════════════════════════════════════════════════════╝${NC}"
}

step() { echo -e "${CYAN}➡️  $1${NC}"; }
ok()   { echo -e "${GREEN}✔️  $1${NC}"; }
err()  { echo -e "${RED}❌  $1${NC}"; }

banner

# ────────────────────────────────────────────────
# 1) Montage VMware
# ────────────────────────────────────────────────
step "Montage du partage VMware"

if mountpoint -q "$MOUNT_POINT"; then
  ok "Déjà monté"
else
  sudo mkdir -p "$MOUNT_POINT"
  sudo mount -t fuse.vmhgfs-fuse ".host:/UBUNTUSAVEW11S" "$MOUNT_POINT" -o allow_other

  if [ $? -ne 0 ]; then
    err "Échec du montage VMware !"
    exit 1
  fi

  ok "Partage VMware monté"
fi

# ────────────────────────────────────────────────
# 2) Vérification du dossier source Windows
# ────────────────────────────────────────────────
step "Vérification du dossier Windows"

if [ ! -d "$SRC_WIN" ]; then
  err "Le dossier Windows $SRC_WIN n'existe pas !"
  exit 1
fi

if [ -z "$(ls -A "$SRC_WIN")" ]; then
  err "Le dossier Windows Nana2 est VIDE !"
  exit 1
fi

ok "Dossier Windows trouvé et non vide"

# ────────────────────────────────────────────────
# 3) Vérification de l'espace disque
# ────────────────────────────────────────────────
step "Vérification de l'espace disque"

REQUIRED=$(du -s "$SRC_WIN" | awk '{print $1}')
AVAILABLE=$(df "$HOME" | awk 'NR==2 {print $4}')

if [ "$AVAILABLE" -lt "$REQUIRED" ]; then
  err "Pas assez d'espace disque pour l'import !"
  echo "Requis : $REQUIRED Ko"
  echo "Disponible : $AVAILABLE Ko"
  exit 1
fi

ok "Espace disque suffisant"

# ────────────────────────────────────────────────
# 4) Reset du dossier Ubuntu Nana2 (sécurisé)
# ────────────────────────────────────────────────
step "Préparation du dossier Ubuntu Nana2"

if [ -z "$DEST_UBU" ] || [ "$DEST_UBU" = "/" ]; then
  err "DEST_UBU est vide ou invalide → sécurité rm -rf activée !"
  exit 1
fi

rm -rf "$DEST_UBU"
mkdir -p "$DEST_UBU"

ok "Dossier Ubuntu prêt"

# ────────────────────────────────────────────────
# 5) Copie Windows → Ubuntu
# ────────────────────────────────────────────────
step "Copie Windows → Ubuntu"

cp -r "$SRC_WIN/"* "$DEST_UBU/"

if [ $? -ne 0 ]; then
  err "Erreur pendant la copie !"
  exit 1
fi

ok "Import terminé"

echo -e "${GREEN}🎉 Import Windows → Ubuntu (Nana2) terminé avec succès !${NC}"
