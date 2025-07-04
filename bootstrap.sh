#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error: bootstrap failed at line $LINENO. Fix the issue and run the script again." >&2' ERR

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

if [[ "$(uname -s)" == "Darwin" ]]; then
  OS_TYPE="mac"
  echo "Detected OS: macOS"
elif command -v pacman >/dev/null 2>&1; then
  OS_TYPE="arch"
  echo "Detected OS: Arch Linux"
elif command -v apt >/dev/null 2>&1 || command -v apt-get >/dev/null 2>&1; then
  OS_TYPE="debian"
  echo "Detected OS: Debian/Ubuntu"
else
  echo "Unsupported OS: neither pacman nor apt found" >&2
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Package Installation per-OS
# ─────────────────────────────────────────────────────────────────────────────
case "$OS_TYPE" in

  # macOS (Homebrew)
  mac)
    command -v brew >/dev/null 2>&1 || {
      /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    }
    brew update
    brew install \
      git stow neovim tmux zsh kitty lsof bat thefuck \
      fzf ripgrep fd zoxide eza yazi
    brew tap homebrew/cask-fonts
    brew install --cask \
      font-jetbrains-mono-nerd-font
    ;;

  # Arch Linux (pacman + yay)
  arch)
    sudo pacman -Sy --needed \
      git base-devel stow neovim tmux zsh kitty \
      netcat lsof bat thefuck fzf ripgrep fd zoxide eza
    command -v yay >/dev/null 2>&1 || {
      git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay
      (cd /tmp/yay && makepkg -si --noconfirm)
      rm -rf /tmp/yay
    }
    yay -Sy --noconfirm \
      yazi nerd-fonts-jetbrains-mono
    ;;

  # Debian/Ubuntu (apt + source builds)
  debian)
    sudo apt update
    sudo apt install -y \
      git build-essential stow tmux zsh kitty lf \
      netcat-openbsd lsof bat thefuck ninja-build \
      gettext cmake unzip curl fzf ripgrep fd-find cargo

    mkdir -p "$HOME/.local/bin"
    [ -e "$HOME/.local/bin/fd" ] || \
      ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"

    # Neovim nightly build
    if dpkg -s neovim >/dev/null 2>&1; then
      sudo apt remove -y neovim
    fi
    if ! command -v nvim >/dev/null 2>&1; then
      tmp=$(mktemp -d)
      git clone  --depth 1\
        https://github.com/neovim/neovim.git "$tmp/neovim"
      (cd "$tmp/neovim" && \
        make CMAKE_BUILD_TYPE=RelWithDebInfo && \
        sudo make install)
      rm -rf "$tmp"
    fi

    # Fonts installation
    mkdir -p "$HOME/.local/share/fonts"
    font_url=$(curl -sI \
      https://github.com/ryanoasis/nerd-fonts/\
releases/latest/download/JetBrainsMono.zip \
      | awk '/^location:/ {print $2}' | tr -d '\r')
    tmpf=$(mktemp)
    curl -L -o "$tmpf" "$font_url"
    unzip -o "$tmpf" -d "$HOME/.local/share/fonts"
    rm "$tmpf"
    command -v fc-cache >/dev/null 2>&1 && \
      fc-cache -fv

    # Warnings for missing tools
    # You'll be prompted at the end to install them
    if ! command -v eza >/dev/null 2>&1; then
      echo
      echo "WARNING: eza is not in Debian repos."
      echo "  See https://github.com/eza-community/eza"
      echo
    fi
    if ! command -v yazi >/dev/null 2>&1; then
      echo
      echo "WARNING: yazi is not in Debian repos."
      echo "  See https://yazi-rs.github.io"
      echo
    fi
    if ! command -v zoxide >/dev/null 2>&1; then
      echo
      echo "WARNING: zoxide is not in Debian repos."
      echo "  See https://github.com/ajeetdsouza/zoxide"
      echo
    fi
    ;;

  # Unsupported OS
  *)
    echo "Unsupported OS"
    exit 1
    ;;
esac

# ─────────────────────────────────────────────────────────────────────────────
# Git Submodules and Dotfile Deployment
# ─────────────────────────────────────────────────────────────────────────────

git submodule update --init --recursive

# Backup existing ~/.zshrc
if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  read -r -p \
    "Found existing ~/.zshrc. Move to ~/.zshrc.bak? [y/N] " ans
  case "$ans" in
    [Yy]*) mv "$HOME/.zshrc" "$HOME/.zshrc.bak" ;;  
  esac
fi

# Deploy dotfiles
stow .

# ─────────────────────────────────────────────────────────────────────────────
# Shell Change and TMUX Plugin Setup
# ─────────────────────────────────────────────────────────────────────────────
if [ "$SHELL" != "$(command -v zsh)" ]; then
  read -r -p \
    "Switch your default shell to Zsh? [Y/n] " ans
  case "$ans" in
    [Nn]*) echo \
      "Skipping shell switch. To change later: chsh -s $(command -v zsh)" ;;
    *)
      chsh -s "$(command -v zsh)" && \
      echo "Shell changed; please log out and log back in."
      ;;
  esac
fi

# TPM bootstrap
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone  --depth 1\
    https://github.com/tmux-plugins/tpm \
    "$HOME/.config/tmux/plugins/tpm"
fi
[ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ] && \
  "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"

# ─────────────────────────────────────────────────────────────────────────────
# Neovim Plugin Sync
# ─────────────────────────────────────────────────────────────────────────────
command -v nvim >/dev/null 2>&1 && \
  nvim --headless "+Lazy! sync" +qa

# ─────────────────────────────────────────────────────────────────────────────
# Debian-only: Prompt and auto-install missing tools
# ─────────────────────────────────────────────────────────────────────────────
if [ "$OS_TYPE" = "debian" ]; then
  echo "(Optional) Install missing Debian-only tools via cargo later [C]ontinue:"
  echo "Install with: [cargo install eza yazi zoxide]"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Hand off to Zsh
# ─────────────────────────────────────────────────────────────────────────────
read -r -p "Start a Zsh session now? [Y/n] " ans
ans=${ans:-Y}
if [[ $ans =~ ^[Yy] ]]; then
  exec zsh
fi
