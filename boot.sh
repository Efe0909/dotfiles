#!/usr/bin/env bash

set -euo pipefail
trap 'status=$?; echo "Error: bootstrap failed with $status at line $LINENO" >&2; exit $status' ERR

test() {
  REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BACKUP_MANIFEST="$REPO_DIR/.bootstrap.backlist"

  cd "$REPO_DIR"
  
  findStowPackages
}
###############################################################################
# Main
###############################################################################
function main() {
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    BACKUP_MANIFEST="$REPO_DIR/.bootstrap.backlist"

    cd "$REPO_DIR"

    detectOs


    if [[ ${1-} == revert ]]; then
        revertConfig
        exit 0
    fi

    findStowPackages
    backupStowPackages

    case "$OS_TYPE" in

        mac)
            installMac
            ;;

        arch)
            installArch
            ;;

        debian)
            installDebian
            ;;
        *)
            echo "Unsupported Os"
            exit 1
            ;;
    esac

    git submodule update --init --recursive

    bootstrapTmux

    bootstrapNeovim

    bootstrapZsh

    if [ "$OS_TYPE" = "debian" ]; then
        debianCargoPackages
    fi

    changeDefaultShell

    reminders

    exec zsh
}

###############################################################################
# detectOs  – sets global $OS_TYPE  (mac | arch | debian | unknown)
###############################################################################
detectOs() {
  # Default
  OS_TYPE="unknown"

  # macOS: uname -s → Darwin
  if [[ $(uname -s 2>/dev/null) == Darwin* ]]; then
    OS_TYPE="mac"
    echo "Detected OS: macOS"
    return
  fi

  # Arch (and derivatives) → presence of pacman
  if command -v pacman >/dev/null 2>&1; then
    OS_TYPE="arch"
    echo "Detected OS: Arch Linux"
    return
  fi

  # Debian / Ubuntu → apt or apt-get
  if command -v apt >/dev/null 2>&1 || command -v apt-get >/dev/null 2>&1; then
    OS_TYPE="debian"
    echo "Detected OS: Debian/Ubuntu"
    return
  fi

  echo "Unsupported OS: neither pacman nor apt found" >&2
}

###############################################################################
# findStowPackages
#   Globals filled:
#     STOW_PACKAGES   → dot-* items in repo root
#     STOW_LINKS_EXIST
#     STOW_LINKS_NEW
#     STOW_CONFLICTS
###############################################################################
findStowPackages() {
  # init globals
  STOW_PACKAGES=()
  STOW_LINKS_EXIST=()
  STOW_LINKS_NEW=()
  STOW_CONFLICTS=() 

  # ── discover packages (dirs *or* files) ────────────────────────────────────
  for item in dot-*; do
    [[ -e $item ]] && STOW_PACKAGES+=("$item")
  done

  if ((${#STOW_PACKAGES[@]} == 0)); then
    echo "No dot-* packages found – nothing to stow."
    return
  fi

  # ── dry-run each package & classify links ─────────────────────────────────
  for pkg in "${STOW_PACKAGES[@]}"; do
    stow -nv "$pkg" 2>&1 || true |           # keep going even on conflicts
    while IFS= read -r line; do
      [[ $line == LINK:* ]] || continue

      # take first token after 'LINK:'  (works for '->' or '=>')
      rel=${line#LINK: }
      rel=${rel%%[[:space:]]*}
      rel=${rel#./}                          # drop leading "./" if present
      dest="$HOME/$rel"

      if [[ -L $dest ]]; then
        STOW_LINKS_EXIST+=("$rel")
      else
        if [[ -e $dest ]]; then
          STOW_CONFLICTS+=("$dest")
        fi
        STOW_LINKS_NEW+=("$rel")
      fi
    done
  done

  # ── summary ───────────────────────────────────────────────────────────────
  echo
  echo "Existing links (${#STOW_LINKS_EXIST[@]}):"
  ((${#STOW_LINKS_EXIST[@]})) && printf '  %s\n' "${STOW_LINKS_EXIST[@]}" || echo "  (none)"

  echo
  echo "To be created (${#STOW_LINKS_NEW[@]}):"
  ((${#STOW_LINKS_NEW[@]})) && printf '  %s\n' "${STOW_LINKS_NEW[@]}" || echo "  (none)"

  echo
  echo "Conflicts (${#STOW_CONFLICTS[@]}):"
  ((${#STOW_CONFLICTS[@]})) && printf '  %s\n' "${STOW_CONFLICTS[@]}" || echo "  (none)"
  echo
}

# ────────────────────────────────────────────────────────────────────────────
# Main entry point
# ────────────────────────────────────────────────────────────────────────────
# main "$@"
test
