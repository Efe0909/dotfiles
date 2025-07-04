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
git clone --recurse-submodules https://github.com/Efe0909/dotfiles.git ~/dotfiles
```

#### Bootstrap script (recomended for new systems)
```bash
chmod +x ~/dotfiles/bootstrap.sh && ~/dotfiles/bootstrap.sh
```
## Using GNU Stow to Manage Dotfiles

If you don't want to use a setup script, you can use [GNU Stow](https://www.gnu.org/software/stow/) to symlink your dotfiles.

### Steps:

1. **Install Stow**  
   On macOS, you can use Homebrew:
   ```sh
   brew install stow
   ```
   On Arch,:
   ```sh
   sudo pacman -S stow
   ```
   On Debian based distros:
   ```sh
   sudo apt install stow
   ```

2. **Clone this repository**  
   ```sh
   git clone https://github.com/Efe0909/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

3. **Stow a package**  
   Each directory (like `zsh`, `vim`, etc.) is a “stow package.” To symlink the files for a package into your home directory:
   ```sh
   stow zsh
   stow vim
   ```
   Add more as needed or apply everything:
   ```sh
   stow .
   ```

This will symlink the files inside each package directory into your home directory, making setup easy and reversible.
