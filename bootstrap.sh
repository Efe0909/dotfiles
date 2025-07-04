#!/usr/bin/env bash
set -e

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
    if ! command -v brew >/dev/null 2>&1; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew update
    brew install git stow neovim tmux zsh kitty yazi lsof bat thefuck
    ;;
  arch)
    sudo pacman -Sy --needed git base-devel stow tmux zsh kitty netcat lsof bat thefuck
    if ! command -v yay >/dev/null 2>&1; then
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay
      makepkg -si --noconfirm
      cd "$REPO_DIR"
      rm -rf /tmp/yay
    fi
    yay -Sy --noconfirm neovim-git yazi
    ;;
  debian)
    sudo apt update
    sudo apt install -y git build-essential stow tmux zsh kitty lf netcat-openbsd lsof bat thefuck ninja-build gettext cmake unzip curl
    if command -v nvim >/dev/null 2>&1; then
      sudo apt remove -y neovim
    fi
    tempdir="$(mktemp -d)"
    git clone https://github.com/neovim/neovim.git "$tempdir/neovim"
    cd "$tempdir/neovim"
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd "$REPO_DIR"
    rm -rf "$tempdir"
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
esac

git submodule update --init --recursive

stow stowrc
stow nvim
stow tmux
stow zsh
stow kitty

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

if [ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
  "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
fi
