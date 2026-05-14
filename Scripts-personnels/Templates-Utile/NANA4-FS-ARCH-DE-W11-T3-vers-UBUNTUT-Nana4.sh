#!/bin/bash
set -e

# ────────────────────────────────────────────────────────────────
# 🧠 BernardOps – Menu Import Windows 11 → Ubuntu (Nana4)
# ────────────────────────────────────────────────────────────────

MOUNT_POINT="/mnt/hgfs"
SRC_WIN="$MOUNT_POINT/Nana4"
DEST_UBU="$HOME/Nana4"

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

banner() {
  clear
  echo -e "${CYAN}╔══════════════════════════════════════════════════════╗"
  echo -e "║ 🧠  BernardOps – Import Windows → Ubuntu (Nana4)     ║"
  echo -e "║ 📅  $(date '+%Y-%m-%d %H:%M')                         ║"
  echo -e "╚══════════════════════════════════════════════════════╝${NC}"
}

step() { echo -e "${CYAN}➡️  $1${NC}"; }
ok()   { echo -e "${GREEN}✔️  $1${NC}"; }
err()  { echo -e "${RED}❌  $1${NC}"; }

# ────────────────────────────────────────────────
# FONCTIONS
# ────────────────────────────────────────────────

mount_vmware() {
  step "Montage du partage VMware"
  if mountpoint -q "$MOUNT_POINT"; then
    ok "Déjà monté"
  else
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount -t fuse.vmhgfs-fuse ".host:/Nana4" "$MOUNT_POINT" -o allow_other
    ok "Partage VMware monté"
  fi
  read -p "Appuie sur Entrée pour continuer..."
}

check_windows_folder() {
  step "Vérification du dossier Windows"
  if [ ! -d "$SRC_WIN" ]; then
    err "Le dossier Windows $SRC_WIN n'existe pas !"
    read -p "Appuie sur Entrée pour continuer..."
    return 1
  fi
  ok "Dossier Windows trouvé"
  read -p "Appuie sur Entrée pour continuer..."
}

reset_ubuntu_folder() {
  step "Préparation du dossier Ubuntu Nana4"
  rm -rf "$DEST_UBU"
  mkdir -p "$DEST_UBU"
  ok "Dossier Ubuntu prêt"
  read -p "Appuie sur Entrée pour continuer..."
}

copy_win_to_ubuntu() {
  step "Copie Windows → Ubuntu"
  cp -r "$SRC_WIN/"* "$DEST_UBU/"
  ok "Import terminé"
  read -p "Appuie sur Entrée pour continuer..."
}

full_import() {
  mount_vmware
  check_windows_folder || return
  reset_ubuntu_folder
  copy_win_to_ubuntu
  echo -e "${GREEN}🎉 Import Windows → Ubuntu (Nana4) terminé avec succès !${NC}"
  read -p "Appuie sur Entrée pour continuer..."
}

# ────────────────────────────────────────────────
# MENU
# ────────────────────────────────────────────────

menu() {
  banner
  echo -e "${YELLOW}Que veux‑tu faire ?${NC}"
  echo "1) Monter le partage VMware"
  echo "2) Vérifier le dossier Windows"
  echo "3) Réinitialiser le dossier Ubuntu Nana4"
  echo "4) Copier Windows → Ubuntu"
  echo "5) Import complet (toutes étapes)"
  echo "0) Quitter"
  echo -n "> "
  read choice

  case $choice in
    1) mount_vmware ;;
    2) check_windows_folder ;;
    3) reset_ubuntu_folder ;;
    4) copy_win_to_ubuntu ;;
    5) full_import ;;
    0) exit 0 ;;
    *) echo -e "${RED}Option invalide${NC}" ;;
  esac

  echo -e "${YELLOW}Appuie sur Entrée pour revenir au menu...${NC}"
  read
  menu
}

menu
