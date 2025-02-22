#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not installed
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Ensure brew is in PATH (needed for fresh installations)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Neovim if not installed
if ! command_exists nvim; then
    echo "Installing Neovim..."
    brew install neovim
else
    echo "Neovim is already installed."
fi

# Install fzf if not installed
if ! command_exists fzf; then
    echo "Installing Fzf..."
    brew install fzf
else
    echo "fzf is already installed."
fi

# Install ripgrep if not installed
if ! command_exists rg; then
    echo "Installing ripgrep..."
    brew install ripgrep
else
    echo "ripgrep is already installed."
fi

# Install Tmux if not installed
if ! command_exists tmux; then
    echo "Installing Tmux..."
    brew install tmux
else
    echo "Tmux is already installed."
fi

# Install iTerm2 if not installed
if [ ! -d "$HOME/Library/Application Support/iTerm2" ]; then
    echo "Installing iTerm2..."
    brew install --cask iterm2
else
    echo "iTerm2 is already installed."
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

if [ ! -f "$HOME/Library/Fonts/CaskaydiaCoveNerdFont-Bold.ttf" ]; then
  echo "Installing Font..."
  brew install --cask font-caskaydia-cove-nerd-font
else
  echo "Font is already installed."
fi

echo "Installation process completed."

# Remove existing Neovim config directory if it's a folder
rm -rf ~/.config/nvim

# Create symlinks for configuration files
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/iterm/iterm2profile.json" "$HOME/Library/Application Support/iterm2/DynamicProfiles/iterm2profile.json"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

echo "Symlinks created"

# Clone repositories if not already cloned
REPOS=(
    "https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    "https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    "https://github.com/joshskidmore/zsh-fzf-history-search $HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search"
)

for repo in "${REPOS[@]}"; do
    read -r URL DIR <<< "$repo"

    # Ensure the parent directory exists
    PARENT_DIR=$(dirname "$DIR")
    mkdir -p "$PARENT_DIR"

    if [ ! -d "$DIR/.git" ]; then
        echo "Cloning $URL into $DIR..."
        git clone "$URL" "$DIR"
    else
        echo "Repository $DIR already exists. Skipping."
    fi
done
