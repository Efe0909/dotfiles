#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error: bootstrap failed at line $LINENO. Fix the issue and run the script again." >&2' ERR

REPO_DIR="${DOTFILES_REPO:-$HOME/dotfiles}"
cd "$REPO_DIR"

if [ "$(uname -s)" = "Darwin" ]; then
  OS_TYPE="mac"
elif [ -f /etc/arch-release ]; then
  OS_TYPE="arch"
elif [ -f /etc/debian_version ]; then
  OS_TYPE="debian"
else
  OS_TYPE="unknown"
fi

case "$OS_TYPE" in
  mac)
    command -v brew >/dev/null 2>&1 || {
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    }
    brew update
    brew install git stow neovim tmux zsh kitty yazi lsof bat thefuck
    ;;
  arch)
    sudo pacman -Sy --needed git base-devel stow neovim tmux zsh kitty netcat lsof bat thefuck yazi
    command -v yay >/dev/null 2>&1 || {
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      (cd /tmp/yay && makepkg -si --noconfirm)
      rm -rf /tmp/yay
    }
    ;;
  debian)
    sudo apt update
    sudo apt install -y git build-essential stow neovim tmux zsh kitty lf netcat-openbsd lsof bat thefuck ninja-build gettext cmake unzip curl
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
esac

git submodule update --init --recursive

if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  read -r -p "Found existing ~/.zshrc. Move to ~/.zshrc.bak? [y/N] " ans
  case "$ans" in
    [Yy]*) mv "$HOME/.zshrc" "$HOME/.zshrc.bak" ;;
  esac
fi

stow .

if [ "$SHELL" != "$(command -v zsh)" ]; then
  read -r -p "Switch your default shell to Zsh? [Y/n] " ans
  case "$ans" in
    [Nn]*) echo "Skipping shell switch." ;;
    *) chsh -s "$(command -v zsh)" ;;
  esac
fi

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

[ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ] && "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
command -v nvim >/dev/null 2>&1 && nvim --headless "+Lazy! sync" +qa

exec zsh
