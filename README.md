# dotfiles

Minimal-but-complete configuration for macOS, Arch Linux, and Debian-based systems.  
One `bootstrap.sh` gets you a fully working environment—editor, shell, terminal, and plugins—without touching files you already have.

---

## ✨ Highlights

| Area | What you get |
|------|--------------|
| **Shell** | Zsh with sensible defaults, autosuggestions, and *thefuck* |
| **Editor** | Neovim nightly (built automatically on Debian) with Lazy-managed plugins |
| **Terminal** | Kitty + Yazi (mac/arch) or LF (debian) |
| **Multiplexer** | Tmux with TPM and common plugins |
| **Package manager** | Homebrew, pacman (+ yay), or apt handled for you |
| **Dotfile manager** | GNU Stow keeps everything clean and atomic |
| **Safety** | Script aborts on error, backs up existing ~/.zshrc, and never overwrites manual files |

---

## 🚀 Quick Start

#### Clone command
```bash
git clone --recurse-submodules https://github.com/you/dotfiles.git ~/dotfiles
```

#### Bootstrap script (recomended for new systems)
```bash
chmod +x ~/dotfiles/bootstrap.sh && ~/dotfiles/bootstrap.sh
```

