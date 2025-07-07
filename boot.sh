#!/usr/bin/env bash

set -euo pipefail
trap 'status=$?; echo "Error: bootstrap failed with $status at line $LINENO" >&2; exit $status' ERR

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
# findStowPackages() determine existing config files that can overlap with stow
###############################################################################
function findStowPackages() {
    
}



# ────────────────────────────────────────────────────────────────────────────
# Main entry point
# ────────────────────────────────────────────────────────────────────────────
main "$@"
