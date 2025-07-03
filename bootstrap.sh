#!/usr/bin/env bash
set -e

REPO_DIR="${DOTFILES_REPO:-$HOME/dotfiles}"
cd "$REPO_DIR"

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    if ! command -v brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew update
    brew install git stow neovim tmux zsh kitty
elif [ -f /etc/arch-release ]; then
    sudo pacman -Sy --needed git stow neovim tmux zsh kitty
elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y git stow neovim tmux zsh kitty
else
    echo "Unsupported OS"
    exit 1
fi

git submodule update --init --recursive

stow stowrc
stow nvim
stow tmux
stow zsh
stow kitty

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

"$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
