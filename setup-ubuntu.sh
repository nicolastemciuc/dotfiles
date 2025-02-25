#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update and install required packages
echo "Updating package list and installing required packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    curl \
    git \
    zsh \
    neovim \
    ripgrep \
    fzf \
    tmux \
    fd-find

# Link fd to fdfind for compatibility
if ! command_exists fd; then
    echo "Linking fdfind to fd..."
    sudo ln -s $(which fdfind) /usr/local/bin/fd
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Install plugins for Zsh
echo "Installing Zsh plugins..."
REPOS=(
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

# Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s $(which zsh)
fi

# Remove existing Neovim config directory if it's a folder
echo "Setting up Neovim configuration..."
rm -rf ~/.config/nvim

# Create symlinks for configuration files
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

echo "Symlinks created successfully."

echo "Installation process completed. Restart your terminal or run 'zsh' to start using the new setup."
